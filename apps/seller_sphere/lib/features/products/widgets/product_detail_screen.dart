// lib/screens/product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

/// Halaman untuk menampilkan detail produk spesifik berdasarkan ID.
class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Produk (ID: $productId)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Menggunakan GoRouter context.pop() untuk kembali dengan aman
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder Gambar Produk
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(AppSpacing.lg),
              ),
              child: const Center(
                child: Icon(Icons.image, size: 80, color: Colors.grey),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Informasi ID Produk
            Text(
              'ID Produk: $productId',
              style: textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Judul / Keterangan
            Text(
              'Informasi Lengkap Produk',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),

            // Deskripsi Singkat
            Text(
              'Halaman ini menampilkan data rinci produk yang dimuat secara dinamis berdasarkan parameter ID yang dikirimkan melalui navigasi GoRouter.',
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}