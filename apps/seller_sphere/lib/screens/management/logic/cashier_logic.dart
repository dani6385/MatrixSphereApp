// lib/screens/management/cashier_logic.dart

import 'package:shared_services/shared_services.dart';

class CashierLogic {
  final ProductService _productService = ProductService();
  
  // State data internal
  final List<CartItem> cartItems = [];
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  // Mengambil daftar produk dari server/database
  Future<void> fetchProducts() async {
    final products = await _productService.getProducts();
    allProducts = products;
    filteredProducts = products;
  }

  // Menghitung total nominal belanjaan
  double calculateTotalAmount() {
    return cartItems.fold(
      0, 
      (sum, item) => sum + (item.product.sellingPrice * item.quantity),
    );
  }

  // Menambahkan produk ke keranjang dengan validasi stok
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
    return null; // Berhasil tanpa pesan error
  }

  // Memperbarui kuantitas produk di keranjang
  String? updateQuantity(int index, int newQuantity) {
    final product = cartItems[index].product;
    if (newQuantity > product.stock) {
      return 'Stok ${product.name} tidak mencukupi.';
    }
    cartItems[index].quantity = newQuantity;
    return null;
  }

  // Menghapus item dari keranjang
  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  // Memfilter produk berdasarkan kata kunci pencarian (Nama atau SKU)
  void filterProducts(String query) {
    final lowerQuery = query.toLowerCase();
    filteredProducts = allProducts.where((product) {
      final nameMatch = product.name.toLowerCase().contains(lowerQuery);
      final skuMatch = product.sku?.toLowerCase().contains(lowerQuery) ?? false;
      return nameMatch || skuMatch;
    }).toList();
  }

  // Proses eksekusi transaksi pembayaran dan pembaruan stok
  Future<bool> executeTransaction(String paymentMethod) async {
    if (cartItems.isEmpty) return false;

    final double totalAmount = calculateTotalAmount();

    // 1. Buat objek Order baru[cite: 6]
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

    // 2. Simpan order ke database[cite: 6]
    final String? newOrderId = await _productService.createOrder(newOrder);
    bool success = false;

    if (newOrderId != null) {
      // 3. Jika berhasil, perbarui stok produk berdasarkan keranjang[cite: 6]
      success = await _productService.updateStockForOrder(cartItems);
    }

    if (success) {
      cartItems.clear(); // Bersihkan keranjang jika transaksi sukses
    }

    return success;
  }
}