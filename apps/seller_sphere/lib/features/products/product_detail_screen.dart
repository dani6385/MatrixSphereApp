import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart'; // Import for firstWhereOrNull
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

/// A screen that displays detailed information about a single product.
class ProductDetailScreen extends StatefulWidget {
  final String productId;
  // shopId mungkin diperlukan jika struktur database Anda memisahkan produk per toko
  final String shopId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.shopId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService _productService = ProductService();
  // Mengubah dari Future ke Stream untuk data real-time
  late Stream<Product?> _productStream;

  @override
  void initState() {
    super.initState();
    // Menggunakan stream yang ada dan memfilternya untuk produk yang spesifik.
    _productStream = _productService.getProductsStream().map((products) => products.firstWhereOrNull((product) => product.id == widget.productId));
  }

  // Fungsi untuk mendapatkan warna indikator berdasarkan jumlah stok
  Color _getStockIndicatorColor(int stock) {
    if (stock > 100) return kSuccess;
    if (stock > 20) return Kwarning;
    return kError;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          // Tombol untuk mengedit produk
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Produk',
            onPressed: () {
              // Navigasi ke halaman edit produk
              context.go(AppRoutes.productEdit.replaceFirst(':productId', widget.productId));
            },
          ),
        ],
      ),
      // Mengganti FutureBuilder dengan StreamBuilder
      body: StreamBuilder<Product?>(
        stream: _productStream,
        builder: (context, snapshot) {
          // Tampilkan loading indicator saat data sedang diambil
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Tampilkan pesan error jika produk tidak ditemukan atau ada masalah
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                'Gagal memuat produk atau produk tidak ditemukan.',
                style: textTheme.bodyLarge,
              ),
            );
          }

          final product = snapshot.data!;

          // Tampilkan detail produk jika data berhasil didapatkan
          return SingleChildScrollView(
            padding: AppStyles.defaultScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder untuk gambar produk
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, size: 80, color: kDarkTextSecondary),
                  ),
                ),
                const SizedBox(height: 24),
                // Nama Produk
                Text(product.name, style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                // Harga dan Stok
                Card(
                  color: colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Rp ${product.price.toStringAsFixed(0)}', style: textTheme.titleLarge?.copyWith(color: kSuccess, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getStockIndicatorColor(product.stock).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('Stok: ${product.stock}', style: textTheme.bodyMedium?.copyWith(color: _getStockIndicatorColor(product.stock), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Deskripsi Produk
                Text('Deskripsi', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(product.description, style: textTheme.bodyLarge?.copyWith(color: kDarkTextSecondary)),
              ],
            ),
          );
        },
      ),
    );
  }
}