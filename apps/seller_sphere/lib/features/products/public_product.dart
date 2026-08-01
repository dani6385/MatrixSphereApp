import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

/// Halaman untuk menampilkan daftar semua produk dari semua toko.
/// Halaman ini mengambil data dari node 'products' di Firebase RTDB.
class PublicProductScreen extends StatefulWidget {
  const PublicProductScreen({super.key});

  @override
  State<PublicProductScreen> createState() => _PublicProductScreenState();
}

class _PublicProductScreenState extends State<PublicProductScreen> {
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchAllProducts();
  }

  /// Mengambil semua data produk dari node top-level 'products'.
  Future<List<Product>> _fetchAllProducts() async {
    final snapshot = await _rtdbService.readData('products');
    if (snapshot != null && snapshot.exists && snapshot.value is Map) {
      final productsData = Map<String, dynamic>.from(snapshot.value as Map);
      final List<Product> productList = [];
      productsData.forEach((productId, productData) {
        if (productData is Map) {
          // Menggunakan Product.fromMap untuk mengurai data produk
          // dan productId sebagai ID-nya.
          productList.add(Product.fromMap(
              Map<String, dynamic>.from(productData), productId));
        }
      });
      return productList;
    }
    // Mengembalikan list kosong jika tidak ada data
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        title: const Text('Semua Produk'),
        backgroundColor: kDarkSecondary,
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          // 1. Menampilkan loading indicator saat data sedang diambil
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Menampilkan pesan error jika terjadi masalah
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat produk: ${snapshot.error}',
                style: const TextStyle(color: kLightTextSecondary),
              ),
            );
          }

          // 3. Mengambil data produk dari snapshot
          final products = snapshot.data;

          // 4. Menampilkan pesan jika tidak ada produk yang ditemukan
          if (products == null || products.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada produk yang tersedia.',
                style: TextStyle(color: kLightTextSecondary),
              ),
            );
          }

          // 5. Menampilkan daftar produk menggunakan ListView.builder
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                color: kDarkSecondary,
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  // Anda bisa menambahkan gambar produk di sini jika ada
                  // leading: Image.network(product.imageUrl),
                  title: Text(product.name,
                      style: const TextStyle(color: kLightTextPrimary)),
                  subtitle: Text(
                    'Stok: ${product.stock}',
                    style: const TextStyle(color: kLightTextSecondary),
                  ),
                  trailing: Text(
                    'Rp ${product.sellingPrice.toStringAsFixed(0)}',
                    style: const TextStyle(color: kBrandPrimary, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}