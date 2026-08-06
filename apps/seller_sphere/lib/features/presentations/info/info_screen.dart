import 'package:flutter/material.dart';

/// Halaman untuk menampilkan informasi tentang aplikasi Seller Sphere.
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Icon(
              Icons.storefront_outlined, // Ikon yang relevan dengan seller
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Seller Sphere',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Versi 1.0.0', // Anda bisa menggantinya dengan versi dinamis
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Divider(height: 40),
            const Text(
              'Aplikasi ini adalah bagian dari ekosistem MatrixSphere, dirancang khusus untuk membantu penjual mengelola toko, produk, pesanan, dan berinteraksi dengan pelanggan secara efisien.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(flex: 3),
            const Text(
              'Dikembangkan oleh MatrixSphere Team',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hak Cipta © 2024 MatrixSphere. Semua hak dilindungi.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}