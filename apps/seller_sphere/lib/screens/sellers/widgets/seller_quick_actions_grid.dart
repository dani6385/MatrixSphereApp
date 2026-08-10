// lib/screens/management/components/seller_quick_actions_grid.dart
import 'package:flutter/material.dart';
import '../models/quick_action_data.dart'; // Sesuaikan path import model
import 'quick_action_card.dart'; // Sesuaikan path import kartu

class SellerQuickActionsGrid extends StatelessWidget {
  const SellerQuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Data untuk aksi cepat
    final List<QuickActionCardData> quickActions = [
      QuickActionCardData(
        title: 'Tambah Produk',
        icon: Icons.add_box,
        description: 'Tambahkan produk baru ke toko Anda.',
        onTap: () {
          debugPrint('Tambah Produk clicked');
        },
      ),
      QuickActionCardData(
        title: 'Kelola Pesanan',
        icon: Icons.receipt_long,
        description: 'Lihat dan proses pesanan yang masuk.',
        onTap: () {
          debugPrint('Kelola Pesanan clicked');
        },
      ),
      QuickActionCardData(
        title: 'Lihat Laporan',
        icon: Icons.bar_chart,
        description: 'Akses laporan penjualan dan performa toko.',
        onTap: () {
          debugPrint('Lihat Laporan clicked');
        },
      ),
      QuickActionCardData(
        title: 'Pengaturan Toko',
        icon: Icons.settings,
        description: 'Sesuaikan pengaturan toko Anda.',
        onTap: () {
          debugPrint('Pengaturan Toko clicked');
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: quickActions.length,
      itemBuilder: (context, index) {
        final action = quickActions[index];
        return QuickActionCard(
          title: action.title,
          icon: action.icon,
          description: action.description,
          onTap: action.onTap,
        );
      },
    );
  }
}