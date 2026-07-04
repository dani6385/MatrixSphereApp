import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

/// Provider untuk mengelola data produk.
///
/// Di aplikasi nyata, provider ini akan bertanggung jawab untuk mengambil
/// data produk dari API atau database lokal.
class ProductProvider with ChangeNotifier {
  // Daftar produk dummy.
  final List<Product> _products = const [
    Product(
      id: '1',
      name: 'Wireless Headphone Alpha',
      price: 1500000,
      imageUrl: 'assets/images/product1.jpg',
      rating: 4.5,
    ),
    Product(
      id: '2',
      name: 'Smart Watch Series 5',
      price: 2200000,
      imageUrl: 'assets/images/product2.jpg',
      rating: 4.8,
    ),
    Product(
      id: '3',
      name: 'Gaming Mouse X10',
      price: 550000,
      imageUrl: 'assets/images/product3.jpg',
      rating: 4.2,
    ),
    Product(
      id: '4',
      name: 'Mechanical Keyboard Z',
      price: 1800000,
      imageUrl: 'assets/images/product4.jpg',
      rating: 4.7,
    ),
  ];

  /// Mengembalikan salinan dari daftar produk.
  List<Product> get products => [..._products];

  /// Mencari produk berdasarkan ID-nya.
  Product findById(String id) {
    return _products.firstWhere((prod) => prod.id == id, orElse: () => _products.first);
  }
}