// d:\MatrixSphereApp\apps\seller_sphere\lib\models\product_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final List<String> imageUrls;
  final double price;
  final int stock;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.imageUrls,
    required this.price,
    required this.stock,
    required this.createdAt,
  });

  
  // ID tidak disertakan karena ID adalah nama dokumen di Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrls': imageUrls,
      'price': price,
      'stock': stock,
      // Konversi DateTime ke Timestamp Firestore
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Membuat objek Product dari Map (dokumen Firestore).
  /// ID dokumen diambil secara terpisah dan diteruskan ke konstruktor.
  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      name: map['name'] ?? '',
      // Pastikan untuk mengonversi List<dynamic> menjadi List<String>
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      price: (map['price'] ?? 0.0).toDouble(),
      stock: map['stock'] ?? 0,
      // Konversi Timestamp Firestore kembali ke DateTime
      createdAt: (map['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }
}
