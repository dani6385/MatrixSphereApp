import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_services/shared_services.dart';


/// Layanan untuk mengelola operasi CRUD produk ke Firebase Realtime Database.
class ProductService {
  final DatabaseReference _productsRef =
      FirebaseDatabase.instance.ref().child('products');

  /// Mendapatkan stream perubahan data produk dari Firebase.
  /// Setiap kali ada data yang berubah di node 'products', stream ini akan
  /// memancarkan daftar produk yang sudah diperbarui.
  Stream<List<Product>> getProductsStream() {
    return _productsRef.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return data.entries.map((entry) {
          // Menggunakan factory fromMap dengan ID dari key Firebase
          return Product.fromMap(
              Map<String, dynamic>.from(entry.value), entry.key);
        }).toList();
      } else {
        // Jika tidak ada data, kembalikan list kosong.
        return [];
      }
    });
  }

  /// Menambahkan produk baru ke database.
  /// Firebase akan secara otomatis membuat ID unik.
  Future<void> addProduct(Product product) {
    // Dapatkan ID unik baru dari Firebase
    final newProductRef = _productsRef.push();
    // Set data produk dengan ID yang sudah didapat
    return newProductRef.set(product.copyWith(id: newProductRef.key).toMap());
  }

  /// Memperbarui data produk yang sudah ada di database.
  /// Membutuhkan produk dengan ID yang valid.
  Future<void> updateProduct(Product product) {
    if (product.id.isEmpty) {
      throw ArgumentError('Product ID tidak boleh kosong untuk update.');
    }
    return _productsRef.child(product.id).update(product.toMap());
  }

  /// Menghapus produk dari database berdasarkan ID.
  Future<void> deleteProduct(String productId) {
    if (productId.isEmpty) {
      throw ArgumentError('Product ID tidak boleh kosong untuk delete.');
    }
    return _productsRef.child(productId).remove();
  }

  getProducts() {}

  Future<String> uploadImageToImgBB({required String imagePath}) async {
    throw UnimplementedError('uploadImageToImgBB not yet implemented');
  }
}