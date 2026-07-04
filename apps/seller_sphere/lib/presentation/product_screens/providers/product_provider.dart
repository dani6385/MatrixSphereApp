import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

// 1. Definisikan provider Riverpod
final productProvider = ChangeNotifierProvider((ref) => ProductProvider());

final Logger _logger = Logger();

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imagePath; // Store the path of the image file

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
  });
}

class ProductProvider with ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products => [..._products];

  Product findById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  void addProduct({
    required String name,
    required double price,
    required String description,
    required File imageFile,
  }) {
    final newProduct = Product(
      id: DateTime.now().toIso8601String(),
      name: name,
      price: price,
      description: description,
      imagePath: imageFile.path,
    );
    _products.add(newProduct);
    notifyListeners();
  }

  void updateProduct({
    required String id,
    required String name,
    required double price,
    required String description,
    File? newImageFile, // Image can be optional when updating
  }) {
    final prodIndex = _products.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final updatedProduct = Product(
        id: id,
        name: name,
        price: price,
        description: description,
        // Use new image if provided, otherwise keep the old one
        imagePath: newImageFile?.path ?? _products[prodIndex].imagePath,
      );
      _products[prodIndex] = updatedProduct;
      notifyListeners();
    } else {
      // Optional: handle case where product is not found
      _logger.w('Product with id $id not found.');
    }
  }

  void deleteProduct(String id) {
    _products.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
