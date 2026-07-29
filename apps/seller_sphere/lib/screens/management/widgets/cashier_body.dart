import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

import 'cart_item_tile.dart';
import 'product_selection_dialog.dart';

/// Widget untuk fitur kasir penjualan langsung.
class CashierBody extends StatefulWidget {
  const CashierBody({super.key});

  @override
  State<CashierBody> createState() => _CashierBodyState();
}

class _CashierBodyState extends State<CashierBody> {
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();
  final List<CartItem> _cartItems = [];

  double get _totalAmount => _cartItems.fold(
      0, (sum, item) => sum + (item.product.sellingPrice * item.quantity));

  void _addProductToCart(Product product) {
    setState(() {
      final index =
          _cartItems.indexWhere((item) => item.product.id == product.id);

      // Cek stok sebelum menambahkan
      if (product.stock <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Stok ${product.name} habis!')));
        return;
      }
      if (index != -1 && _cartItems[index].quantity < product.stock) {
        _cartItems[index].quantity++;
      } else {
        _cartItems.add(CartItem(product: product, quantity: 1));
      }
    });
  }

  void _updateQuantity(int index, int newQuantity) {
    final product = _cartItems[index].product;
    if (newQuantity > product.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stok ${product.name} tidak mencukupi.')));
      return;
    }

    setState(() {
      _cartItems[index].quantity = newQuantity;
    });
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  Future<void> _showProductSelection() async {
    // Menampilkan dialog dan menunggu hasilnya (produk yang dipilih)
    final selectedProduct = await showDialog<Product>(
      context: context,
      builder: (context) => const ProductSelectionDialog(),
    );

    if (selectedProduct != null) {
      _addProductToCart(selectedProduct);
    }
  }

  void _processPayment(String paymentMethod) {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keranjang masih kosong!')),
      );
      return;
    }
    _executeTransaction(paymentMethod);
  }

  Future<void> _executeTransaction(String paymentMethod) async {
    // Tampilkan dialog loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    // 1. Buat objek Order
    final newOrder = Order(
      id: '', // ID akan digenerate oleh Firebase push()
      orderDate: DateTime.now(),
      totalAmount: _totalAmount,
      paymentMethod: paymentMethod,
      status: OrderStatus.completed, // Use the enum value
      items: _cartItems
          .map((cartItem) => OrderItem(
                productId: cartItem.product.id,
                productName: cartItem.product.name,
                price: cartItem.product.sellingPrice,
                quantity: cartItem.quantity,
              ))
          .toList(),
      orderId: '', customerName: '', customerEmail: '', customerPhone: '',
    );

    // 2. Simpan order dan update stok
    final success = await _rtdbService.createPosOrderAndUpdateStock(
      order: newOrder,
      cartItems: _cartItems,
    );

    if (!mounted) return;

    // Tutup dialog loading
    Navigator.of(context).pop();

    // 3. Tampilkan hasil transaksi
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(success ? 'Pembayaran Berhasil' : 'Transaksi Gagal'),
        content: Text(success
            ? 'Transaksi sebesar ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(_totalAmount)} telah diproses.'
            : 'Gagal memproses transaksi. Stok mungkin tidak mencukupi atau terjadi masalah koneksi.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              if (success) {
                setState(() =>
                    _cartItems.clear()); // Kosongkan keranjang jika berhasil
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedTotal =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(_totalAmount);

    return Column(
      children: [
        // Daftar item di keranjang
        Expanded(
          child: _cartItems.isEmpty
              ? const Center(
                  child:
                      Text('Keranjang kosong. Tambahkan produk untuk memulai.'))
              : ListView.builder(
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final item = _cartItems[index];
                    return CartItemTile(
                      cartItem: item,
                      onQuantityChanged: (newQuantity) =>
                          _updateQuantity(index, newQuantity),
                      onRemove: () => _removeItem(index),
                    );
                  },
                ),
        ),
        // Bagian Total dan Pembayaran
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, -2)),
            ],
          ),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: _showProductSelection,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Tambah Produk'),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48)),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 18)),
                  Text(formattedTotal,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () => _processPayment('Tunai'),
                          child: const Text('TUNAI'))),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () => _processPayment('Non-Tunai'),
                          child: const Text('NON-TUNAI'))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
