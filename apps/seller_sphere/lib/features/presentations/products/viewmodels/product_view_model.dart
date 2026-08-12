<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055

// lib/viewmodels/product_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/product_model.dart';

/// ViewModel untuk mengelola daftar produk dan logika bisnis terkait.[cite: 13]
class ProductViewModel extends ChangeNotifier {
  final List<Product> _products = [];
  bool _isLoading = false;
  final Uuid _uuid = const Uuid();

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  ProductViewModel() {
    _fetchProducts();
  }

  /// Mensimulasikan pengambilan data produk dari sumber eksternal.[cite: 13]
  void _fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _products.addAll([
      Product(id: _uuid.v4(), name: 'Laptop Gaming', price: 1500.00, stock: 10),
      Product(id: _uuid.v4(), name: 'Smartphone Terbaru', price: 800.00, stock: 25),
      Product(id: _uuid.v4(), name: 'Keyboard Mekanik', price: 120.00, stock: 50),
      Product(id: _uuid.v4(), name: 'Mouse Wireless', price: 45.00, stock: 100),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  /// Menambahkan produk baru ke daftar.[cite: 13]
  void addProduct(String name, double price, int stock) {
    final newProduct = Product(
      id: _uuid.v4(),
      name: name,
      price: price,
      stock: stock,
    );
    _products.add(newProduct);
    notifyListeners();
  }

  /// Memperbarui produk yang sudah ada di daftar.[cite: 13]
  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  /// Menghapus produk dari daftar berdasarkan ID.[cite: 13]
  void deleteProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}
<<<<<<< HEAD
=======

// lib/viewmodels/product_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/product_model.dart';

/// ViewModel untuk mengelola daftar produk dan logika bisnis terkait.[cite: 13]
class ProductViewModel extends ChangeNotifier {
  final List<Product> _products = [];
  bool _isLoading = false;
  final Uuid _uuid = const Uuid();

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  ProductViewModel() {
    _fetchProducts();
  }

  /// Mensimulasikan pengambilan data produk dari sumber eksternal.[cite: 13]
  void _fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _products.addAll([
      Product(id: _uuid.v4(), name: 'Laptop Gaming', price: 1500.00, stock: 10),
      Product(id: _uuid.v4(), name: 'Smartphone Terbaru', price: 800.00, stock: 25),
      Product(id: _uuid.v4(), name: 'Keyboard Mekanik', price: 120.00, stock: 50),
      Product(id: _uuid.v4(), name: 'Mouse Wireless', price: 45.00, stock: 100),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  /// Menambahkan produk baru ke daftar.[cite: 13]
  void addProduct(String name, double price, int stock) {
    final newProduct = Product(
      id: _uuid.v4(),
      name: name,
      price: price,
      stock: stock,
    );
    _products.add(newProduct);
    notifyListeners();
  }

  /// Memperbarui produk yang sudah ada di daftar.[cite: 13]
  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  /// Menghapus produk dari daftar berdasarkan ID.[cite: 13]
  void deleteProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
