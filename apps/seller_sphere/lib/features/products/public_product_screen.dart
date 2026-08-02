import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shared_services/shared_services.dart';

/// Layar untuk menampilkan ringkasan stok produk di gudang.
/// Mengambil data secara real-time dari Firebase menggunakan ProductService.
class PublicProductScreen extends StatefulWidget {
  const PublicProductScreen({super.key});

  @override
  State<PublicProductScreen> createState() => _PublicProductScreenState();
}

class _PublicProductScreenState extends State<PublicProductScreen> {
  // Instance dari ProductService untuk berinteraksi dengan database.
  final ProductService _productService = ProductService();

  // Fungsi untuk mendapatkan warna indikator berdasarkan jumlah stok
  Color _getStockIndicatorColor(int stock) {
    if (stock > 100) {
      return kSuccess; // Hijau untuk stok banyak
    } else if (stock > 20) {
      return Kwarning; // Oranye untuk stok sedang
    } else {
      return kError; // Merah untuk stok sedikit
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // AppBar akan menggunakan gaya dari tema global
      appBar: AppBar(
        title: const Text('Gudang Stok Produk'),
      ),
      // Menggunakan StreamBuilder untuk menampilkan data produk secara real-time.
      body: StreamBuilder<List<Product>>(
        stream: _productService.getProductsStream(),
        builder: (context, snapshot) {
          // Tampilkan indikator loading saat data sedang diambil.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Tampilkan pesan error jika terjadi masalah.
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          // Tampilkan pesan jika tidak ada produk.
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada produk di gudang.'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                color: colorScheme.surface,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(product.name, style: textTheme.titleMedium),
                  subtitle: Text(
                    'ID: ${product.id}',
                    style: textTheme.bodySmall
                        ?.copyWith(color: kDarkTextSecondary),
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStockIndicatorColor(product.stock)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Stok: ${product.stock}',
                      style: textTheme.bodyMedium?.copyWith(
                          color: _getStockIndicatorColor(product.stock),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman produk untuk menambah produk baru
          context.go(AppRoutes.products);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
