import 'package:flutter/material.dart';

/// Halaman simulasi untuk pedagang olahan angkringan.
/// Dirancang untuk membantu memperkirakan potensi keuntungan,
/// mengelola stok, dan merencanakan strategi penjualan.
class SimulationScreen extends StatelessWidget {
  const SimulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulasi Olahan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang di halaman simulasi untuk pedagang olahan!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Halaman ini dirancang untuk membantu Anda memperkirakan potensi keuntungan, mengelola stok, dan merencanakan strategi penjualan untuk usaha olahan Anda.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Fitur yang mungkin akan tersedia di sini:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            _buildSimulationFeatureItem(
                context,
                'Perhitungan Modal Awal',
                'Estimasi biaya bahan baku, peralatan, dan operasional yang dibutuhkan.'),
            _buildSimulationFeatureItem(
                context,
                'Proyeksi Penjualan',
                'Memprediksi pendapatan berdasarkan harga jual, volume produk, dan faktor musiman.'),
            _buildSimulationFeatureItem(
                context,
                'Manajemen Stok',
                'Simulasi pengelolaan inventaris untuk menghindari kelebihan atau kekurangan stok bahan.'),
            _buildSimulationFeatureItem(
                context,
                'Analisis Keuntungan',
                'Melihat potensi keuntungan bersih dari berbagai skenario bisnis yang berbeda.'),
            const SizedBox(height: 24.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Implement simulation logic or navigate to simulation setup
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur simulasi akan segera hadir!')),
                  );
                },
                child: const Text('Mulai Simulasi'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimulationFeatureItem(BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: Theme.of(context).primaryColor, size: 20),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}