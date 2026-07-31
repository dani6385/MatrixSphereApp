// lib/screens/management/cashier_logic.dart

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

  // Getter total amount
  double get totalAmount => cartItems.fold(
      0, (sum, item) => sum + (item.product.sellingPrice * item.quantity));
// lib/screens/management/logic/cashier_logic.dart

// Tambahkan variabel di dalam kelas CashierLogic:
  double cashPaid = 0.0;
  double get changeAmount =>
      cashPaid > totalAmount ? cashPaid - totalAmount : 0.0;
  bool get isCashValid => cashPaid >= totalAmount;

// Fungsi untuk memperbarui jumlah uang tunai yang dimasukkan
  void updateCashPaid(String value) {
    cashPaid = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0.0;
  }

  // Inisialisasi data produk & listener pencarian
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

    switch (currentSortOption) {
      case ProductSortOption.none:
        break;
      case ProductSortOption.mostSold:
        filteredProducts.sort((a, b) => b.soldCount.compareTo(a.soldCount));
        break;
      case ProductSortOption.priceLowToHigh:
        filteredProducts
            .sort((a, b) => a.sellingPrice.compareTo(b.sellingPrice));
        break;
      case ProductSortOption.priceHighToLow:
        filteredProducts
            .sort((a, b) => b.sellingPrice.compareTo(a.sellingPrice));
        break;
      case ProductSortOption.nameAsc:
        filteredProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ProductSortOption.nameDesc:
        filteredProducts.sort((a, b) => b.name.compareTo(a.name));
        break;
    }
  }

  void changeSortOption(ProductSortOption? newOption, VoidCallback onUpdate) {
    if (newOption != null && newOption != currentSortOption) {
      currentSortOption = newOption;
      applyFilterAndSort();
      onUpdate();
    }
  }

  // Eksekusi Transaksi Pembayaran
  Future<Map<String, dynamic>> executeTransaction(String paymentMethod) async {
    if (cartItems.isEmpty) {
      return {'success': false, 'message': 'Keranjang masih kosong!'};
    }

    final newOrder = Order(
      id: '',
      orderDate: DateTime.now(),
      totalAmount: totalAmount,
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
      customerPhone: '',
    );

    final String? newOrderId = await _productService.createOrder(newOrder);
    bool success = false;

    if (newOrderId != null) {
      success = await _productService.updateStockForOrder(cartItems);
    }

    if (success) {
      cartItems.clear();
    }

    return {'success': success, 'total': totalAmount};
  }
}
