import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  
  /// Fetches a single product from the database by its ID.
  ///
  /// Returns a [Product] object if found, otherwise returns null.
  Future<Product?> getProductById(String productId) async {
    try {
      // Mengambil data dari node produk dengan ID yang spesifik
      final snapshot = await _productsRef.child(productId).get();

      if (snapshot.exists && snapshot.value != null) {
        // Jika data ditemukan, konversi menjadi objek Product
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        return Product.fromMap(data, snapshot.key!);
      }
      return null;
    } catch (e) {
      print('Error fetching product by ID: $e');
      return null;
    }
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
  /// Membuat pesanan baru ke database Firebase pada node 'orders'
  /// Membuat pesanan baru ke database Firebase pada node 'orders'
  Future<String?> createOrder(Order order) async {
    try {
      final DatabaseReference ordersRef =
          FirebaseDatabase.instance.ref().child('orders');
      
      // 1. Buat referensi key unik baru untuk order
      final newOrderRef = ordersRef.push();
      final String newOrderId = newOrderRef.key ?? '';

      // 2. Buat instance Order baru dengan menyertakan ID tanpa memanggil copyWith
      final orderWithId = Order(
        id: newOrderId,
        orderId: newOrderId,
        orderDate: order.orderDate,
        totalAmount: order.totalAmount, // Keep totalAmount
        paymentMethod: order.paymentMethod, // Keep paymentMethod
        status: order.status,
        items: order.items,
        customerName: order.customerName,
        customerEmail: order.customerEmail,
        customerPhone: order.customerPhone,
      );

      // 3. Simpan ke database Firebase
      await newOrderRef.set(orderWithId.toMap());

      return newOrderId; // Mengembalikan ID pesanan jika berhasil
    } catch (e) {
      print('Gagal membuat order: $e');
      return null;
    }
  }

  /// Memperbarui stok produk berdasarkan item yang dibeli di keranjang
  Future<bool> updateStockForOrder(List<CartItem> cartItems) async {
    try {
      for (var cartItem in cartItems) {
        final productId = cartItem.product.id;
        final int currentStock = cartItem.product.stock;
        final int purchasedQty = cartItem.quantity;
        
        final int updatedStock = currentStock - purchasedQty;

        // Update stok produk di database
        await _productsRef.child(productId).update({
          'stock': updatedStock >= 0 ? updatedStock : 0,
        });
      }
      return true;
    } catch (e) {
      print('Gagal memperbarui stok: $e');
      return false;
    }
  }

  /// Menampilkan dialog untuk memperbarui stok produk.
  Future<bool> showStockUpdateDialog(BuildContext context, Product product) async {
    final stockController = TextEditingController(text: product.stock.toString());
    final formKey = GlobalKey<FormState>();

    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Stok: ${product.name}'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Stok Baru'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Stok tidak boleh kosong';
                }
                if (int.tryParse(value) == null) {
                  return 'Masukkan angka yang valid';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newStock = int.parse(stockController.text);
                  try {
                    await updateProduct(product.copyWith(stock: newStock));
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop(true); // Berhasil
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal update stok: $e')),
                    );
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}