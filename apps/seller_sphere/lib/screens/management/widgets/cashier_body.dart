// lib/screens/management/cashier_body.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/screens/management/widgets/scanner_screen.dart';
import 'package:shared_services/shared_services.dart';

import 'cart_item_tile.dart';
import 'product_selection_dialog.dart';
import 'cashier_bottom_panel.dart'; // Impor panel bawah

/// Widget untuk fitur kasir penjualan langsung.
class CashierBody extends StatefulWidget {
  const CashierBody({super.key});

  @override
  State<CashierBody> createState() => _CashierBodyState();
}

class _CashierBodyState extends State<CashierBody> {
  final ProductService _productService = ProductService();
  final List<CartItem> _cartItems = [];
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  double get _totalAmount => _cartItems.fold(
      0, (sum, item) => sum + (item.product.sellingPrice * item.quantity));

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    final products = await _productService.getProducts();
    setState(() {
      _allProducts = products;
      _filteredProducts = products;
    });
  }

  void _addProductToCart(Product product) {
    setState(() {
      final index =
          _cartItems.indexWhere((item) => item.product.id == product.id);

      if (product.stock <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Stok ${product.name} habis!')));
        return;
      }
      if (index != -1 && _cartItems[index].quantity < product.stock) {
        _cartItems[index].quantity++;
      } else if (index == -1) {
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

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final nameMatch = product.name.toLowerCase().contains(query);
        final skuMatch = product.sku?.toLowerCase().contains(query) ?? false;
        return nameMatch || skuMatch;
      }).toList();
    });
  }

  Future<void> _showProductSelection() async {
    final selectedProduct = await showDialog<Product>(
      context: context,
      builder: (context) => ProductSelectionDialog(
        products: _filteredProducts,
      ),
    );

    if (selectedProduct != null) {
      _addProductToCart(selectedProduct);
    }
  }

  Future<void> _scanBarcode() async {
    final String? barcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const ScannerScreen()),
    );

    if (!mounted) return;

    if (barcode != null) {
      final productIndex =
          _allProducts.indexWhere((p) => p.sku == barcode);

      if (productIndex != -1) {
        _addProductToCart(_allProducts[productIndex]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produk dengan SKU "$barcode" tidak ditemukan.')));
      }
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    final newOrder = Order(
      id: '',
      orderDate: DateTime.now(),
      totalAmount: _totalAmount,
      paymentMethod: paymentMethod,
      status: OrderStatus.completed,
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

    final String? newOrderId = await _productService.createOrder(newOrder);
    bool success = false;

    if (newOrderId != null) {
      success = await _productService.updateStockForOrder(_cartItems);
    }

    if (!mounted) return;

    Navigator.of(context).pop();

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
                setState(() => _cartItems.clear());
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Daftar item di keranjang
        Expanded(
          child: _cartItems.isEmpty
              ? const Center(
                  child: Text(
                    'Keranjang kosong.\nCari atau pindai produk untuk memulai.',
                    textAlign: TextAlign.center,
                  ),
                )
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
        // Memanggil widget panel bawah yang telah dipisahkan
        CashierBottomPanel(
          searchController: _searchController,
          onSearchTap: _showProductSelection,
          onScanBarcode: _scanBarcode,
          formattedTotal: formattedTotal,
          onProcessPayment: _processPayment,
        ),
      ],
    );
  }
}