// lib/screens/management/cashier_logic.dart

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import '../widgets/cashier_sort_dropdown.dart';

class CashierLogic {
  final ProductService _productService = ProductService();

  // State data
  final List<CartItem> cartItems = [];
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  ProductSortOption currentSortOption = ProductSortOption.none;
  final TextEditingController searchController = TextEditingController();

  // Getter total amount belanja
  double get totalAmount => cartItems.fold(
      0, (sum, item) => sum + (item.product.sellingPrice * item.quantity));

  double cashPaid = 0.0;
  double get changeAmount =>
      cashPaid > totalAmount ? cashPaid - totalAmount : 0.0;
  bool get isCashValid => cashPaid >= totalAmount;

  void updateCashPaid(String value) {
    cashPaid = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;
  }

  Future<void> init(VoidCallback onUpdate) async {
    await fetchProducts(onUpdate);
    searchController.addListener(onUpdate);
  }

  void dispose() {
    searchController.dispose();
  }

  Future<void> fetchProducts(VoidCallback onUpdate) async {
    final products = await _productService.getProducts();
    allProducts = products;
    applyFilterAndSort();
    onUpdate();
  }

  String? addProductToCart(Product product) {
    if (product.stock <= 0) {
      return 'Stok ${product.name} habis!';
    }
    final index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1 && cartItems[index].quantity < product.stock) {
      cartItems[index].quantity++;
    } else if (index == -1) {
      cartItems.add(CartItem(product: product, quantity: 1));
    }
    return null;
  }

  String? updateQuantity(int index, int newQuantity) {
    final product = cartItems[index].product;
    if (newQuantity > product.stock) {
      return 'Stok ${product.name} tidak mencukupi.';
    }
    cartItems[index].quantity = newQuantity;
    return null;
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  void applyFilterAndSort() {
    final query = searchController.text.toLowerCase();
    filteredProducts = allProducts.where((product) {
      final nameMatch = product.name.toLowerCase().contains(query);
      final skuMatch = product.sku?.toLowerCase().contains(query) ?? false;
      return nameMatch || skuMatch;
    }).toList();
  }

  void changeSortOption(ProductSortOption? newOption, VoidCallback onUpdate) {
    if (newOption != null && newOption != currentSortOption) {
      currentSortOption = newOption;
      applyFilterAndSort();
      onUpdate();
    }
  }

  // ==========================================
  // PECAHAN 1: Membuat Objek Order
  // ==========================================
  Order _buildOrderPayload(String paymentMethod, double total) {
    return Order(
      shopId:
          '', // For cashier transactions, shopId might be determined elsewhere or not directly relevant.
      buyerId:
          '', // For cashier transactions, buyerId might not be available or relevant.
      orderDate: DateTime.now(),
      totalAmount: total,
      paymentMethod: paymentMethod,
      status: OrderStatus.completed,
      items: cartItems
          .map((cartItem) => OrderItem(
                productId: cartItem.product.id,
                productName: cartItem.product.name,
                price: cartItem.product.sellingPrice,
                quantity: cartItem.quantity,
              ))
          .toList(),
      orderId: '',
      customerName: '',
      customerEmail: '',
      customerPhone: '', id: '',
    );
  }

  // ==========================================
  // PECAHAN 2: Mencatat Riwayat ke Firebase
  // ==========================================
  Future<void> _saveTransactionHistory(String transactionId, double total,
      double feeDeduction, String paymentMethod) async {
    final dbRef = FirebaseDatabase.instance.ref();
    await dbRef.child('transactions').child(transactionId).set({
      'id': transactionId,
      'totalAmount': total,
      'feeDeducted': feeDeduction,
      'paymentMethod': paymentMethod,
      'changeAmount': paymentMethod.toLowerCase() == 'tunai' ? changeAmount : 0,
      'status': 'Berhasil',
      'timestamp': ServerValue.timestamp,
      'items': cartItems
          .map((item) => {
                'productId': item.product.id,
                'productName': item.product.name,
                'quantity': item.quantity,
                'price': item.product.sellingPrice,
              })
          .toList(),
    });
  }

  // ==========================================
  // PECAHAN 3: Memotong Saldo Top-Up Penjual (2%)
  // ==========================================
  Future<void> _deductSellerBalance(double feeDeduction) async {
    final dbRef = FirebaseDatabase.instance.ref();
    final sellerSaldoRef = dbRef.child('seller/saldo');
    await sellerSaldoRef.runTransaction((mutableData) {
      double currentSaldo = 0.0;
      if (mutableData != null) {
        currentSaldo = double.tryParse(mutableData.toString()) ?? 0.0;
      }
      double updatedSaldo = currentSaldo - feeDeduction;
      if (updatedSaldo < 0) updatedSaldo = 0;
      return Transaction.success(updatedSaldo);
    });
  }

  // ==========================================
  // FUNGSI UTAMA: Eksekusi Transaksi
  // ==========================================
  Future<Map<String, dynamic>> executeTransaction(String paymentMethod) async {
    if (cartItems.isEmpty) {
      return {'success': false, 'message': 'Keranjang masih kosong!'};
    }

    final double total = totalAmount;
    final double feeDeduction = total * 0.02; // Potongan 2%

    // 1. Buat data order
    final newOrder = _buildOrderPayload(paymentMethod, total);

    // 2. Kirim order ke service
    final String? newOrderId = await _productService.createOrder(newOrder);
    bool success = false;

    if (newOrderId != null) {
      // 3. Perbarui stok produk
      success = await _productService.updateStockForOrder(cartItems);

      if (success) {
        try {
          final transactionId = 'TRX-${DateTime.now().millisecondsSinceEpoch}';

          // 4. Jalankan fungsi terpecah: Simpan riwayat & potong saldo
          await _saveTransactionHistory(
              transactionId, total, feeDeduction, paymentMethod);
          await _deductSellerBalance(feeDeduction);
        } catch (e) {
          debugPrint("Gagal memproses riwayat atau saldo penjual: $e");
        }

        cartItems.clear();
      }
    }

    return {
      'success': success,
      'total': total,
      'transactionId': newOrderId,
      'items': List.from(cartItems),
    };
  }

  Future<void> processPaymentSafe(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      debugPrint("Terjadi error: $e");
    } finally {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
