// lib/services/product_service.dart

import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_services/shared_services.dart';

/// Layanan untuk mengelola operasi CRUD produk ke Firebase Realtime Database.
class ProductService {
  final DatabaseReference _productsRef =
      FirebaseDatabase.instance.ref().child('products');

  /// Mendapatkan stream perubahan data produk dari Firebase.
  Stream<List<Product>> getProductsStream() {
    return _productsRef.onValue.map((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return data.entries.map((entry) {
          return Product.fromMap(
              Map<String, dynamic>.from(entry.value), entry.key);
        }).toList();
      } else {
        return [];
      }
    });
  }

  /// Mengambil satu produk berdasarkan ID.
  Future<Product?> getProductById(String productId) async {
    try {
      final snapshot = await _productsRef.child(productId).get();

      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return Product.fromMap(data, snapshot.key!);
      }
      return null;
    } catch (e) {
      print('Error fetching product by ID: $e');
      return null;
    }
  }

  /// Mengambil daftar produk secara langsung (future).
  Future<List<Product>> getProducts() async {
    try {
      final snapshot = await _productsRef.get();
      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return data.entries.map((entry) {
          return Product.fromMap(
              Map<String, dynamic>.from(entry.value), entry.key);
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  /// Menambahkan produk baru ke database.
  Future<void> addProduct(Product product) {
    final newProductRef = _productsRef.push();
    return newProductRef.set(product.copyWith(id: newProductRef.key).toMap());
  }

  /// Memperbarui data produk yang sudah ada di database.
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

  Future<String> uploadImageToImgBB({required String imagePath}) async {
    throw UnimplementedError('uploadImageToImgBB not yet implemented');
  }

  showStockUpdateDialog(BuildContext context, Product product) {}

  Future<String?> createOrder(Order newOrder) async {
    return null;
  }

  /// Memperbarui stok produk berdasarkan item yang dibeli di keranjang
  Future<bool> updateStockForOrder(List<CartItem> cartItems) async {
    try {
      for (var cartItem in cartItems) {
        final productId = cartItem.product.id;
        final int currentStock = cartItem.product.stock;
        final int purchasedQty = cartItem.quantity;

        final int updatedStock = currentStock - purchasedQty;

        // Update stok produk di database Firebase
        await _productsRef.child(productId).update({
          'stock': updatedStock >= 0 ? updatedStock : 0,
        });
      }

      // PERBAIKAN: Kembalikan nilai true jika perulangan berhasil tanpa eror
      return true;
    } catch (e) {
      print('Gagal memperbarui stok: $e');

      // PERBAIKAN: Kembalikan nilai false jika terjadi pengecualian (catch error)
      return false;
    }
  }
}
