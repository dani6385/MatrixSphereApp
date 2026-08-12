import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// Halaman untuk menampilkan informasi tentang aplikasi.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seller Sphere', // Placeholder for app name
              style: AppStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.cardColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Versi: 1.0.0 (Build 1)', // Placeholder for app version
              style: AppStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: context.cardColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aplikasi ini dirancang untuk membantu para penjual mengelola produk, pesanan, dan pelanggan mereka dengan lebih mudah dan efisien.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fitur Utama:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('- Manajemen Produk'),
            const Text('- Pelacakan Pesanan'),
            const Text('- Analisis Penjualan'),
            const Text('- Notifikasi Real-time'),
            const SizedBox(height: 16),
            const Text(
              'Pengembang: MatrixSphere Team',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hak Cipta © 2023 MatrixSphere. Semua hak dilindungi undang-undang.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Spacer(),
            Center(
              child: Icon(
                Icons.store, // Placeholder for an app icon
                size: 80,
                color: context.primary,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
