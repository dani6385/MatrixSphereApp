
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SellerQuickActionsGrid extends StatelessWidget {
  const SellerQuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {

    // Data untuk aksi cepat
    final List<_QuickActionCardData> quickActions = [
      _QuickActionCardData(
        title: 'Tambah Produk',
        icon: Icons.add_box,
        description: 'Tambahkan produk baru ke toko Anda.',
        onTap: () {
          // Aksi ketika kartu diklik
          debugPrint('Tambah Produk clicked');
        },
      ),
      _QuickActionCardData(
        title: 'Kelola Pesanan',
        icon: Icons.receipt_long,
        description: 'Lihat dan proses pesanan yang masuk.',
        onTap: () {
          debugPrint('Kelola Pesanan clicked');
        },
      ),
      _QuickActionCardData(
        title: 'Lihat Laporan',
        icon: Icons.bar_chart,
        description: 'Akses laporan penjualan dan performa toko.',
        onTap: () {
          debugPrint('Lihat Laporan clicked');
        },
      ),
      _QuickActionCardData(
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
        childAspectRatio: 0.9, // Sesuaikan rasio aspek agar konten pas
      ),
      itemCount: quickActions.length,
      itemBuilder: (context, index) {
        final action = quickActions[index];
        return _QuickActionCard(
          title: action.title,
          icon: action.icon,
          description: action.description,
          onTap: action.onTap,
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppStyles.dateDisplay(Theme.of(context).textTheme).copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppStyles.secondarySubtitle(Theme.of(context).textTheme).copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCardData {
  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  _QuickActionCardData({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
  });
}
