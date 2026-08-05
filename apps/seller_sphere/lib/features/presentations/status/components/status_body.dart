// lib/features/presentations/status/widgets/status_body.dart

import 'package:flutter/material.dart';
// import 'package:shared_services/shared_services.dart'; // Uncomment if you have a ShopService
import 'status_card.dart';

/// Widget yang menjadi body utama dari halaman status toko.
/// Menampilkan berbagai informasi status toko dalam bentuk kartu.
class StatusBody extends StatelessWidget {
  const StatusBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Untuk aplikasi nyata, Anda akan mengambil data ini dari layanan (misalnya ShopService).
    // Untuk saat ini, kita menggunakan data dummy.
    final ShopStatus dummyShopStatus = ShopStatus(
      isApproved: true,
      rating: 4.5,
      totalReviews: 125,
      isActive: true,
      lastUpdated: DateTime.now(),
    );

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        StatusCard(
          title: 'Status Persetujuan Toko',
          value: dummyShopStatus.isApproved ? 'Disetujui' : 'Menunggu Persetujuan',
          icon: dummyShopStatus.isApproved ? Icons.check_circle_outline : Icons.pending_actions,
          valueColor: dummyShopStatus.isApproved ? Colors.green : Colors.orange,
        ),
        StatusCard(
          title: 'Rating Toko',
          value: '${dummyShopStatus.rating.toStringAsFixed(1)} / 5.0',
          icon: Icons.star_half,
          valueColor: Colors.amber[700],
        ),
        StatusCard(
          title: 'Total Ulasan',
          value: '${dummyShopStatus.totalReviews} Ulasan',
          icon: Icons.reviews_outlined,
        ),
        StatusCard(
          title: 'Status Aktif',
          value: dummyShopStatus.isActive ? 'Aktif' : 'Tidak Aktif',
          icon: dummyShopStatus.isActive ? Icons.toggle_on : Icons.toggle_off,
          valueColor: dummyShopStatus.isActive ? Colors.green : Colors.red,
        ),
        StatusCard(
          title: 'Terakhir Diperbarui',
          value: '${dummyShopStatus.lastUpdated.day}/${dummyShopStatus.lastUpdated.month}/${dummyShopStatus.lastUpdated.year}',
          icon: Icons.update,
        ),
        // Tambahkan lebih banyak kartu status sesuai kebutuhan
      ],
    );
  }
}

/// Model dummy untuk status toko.
/// Dalam aplikasi nyata, ini mungkin berada di direktori `models` atau `shared_services`.
class ShopStatus {
  final bool isApproved;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final DateTime lastUpdated;

  ShopStatus({
    required this.isApproved,
    required this.rating,
    required this.totalReviews,
    required this.isActive,
    required this.lastUpdated,
  });
}