
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:intl/intl.dart'; // Impor untuk format tanggal dan waktu

class SellerRecentActivityList extends StatelessWidget {
  const SellerRecentActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Data dummy untuk aktivitas terbaru
    final List<_ActivityItemData> activities = [
      _ActivityItemData(
        title: 'Pesanan Baru Diterima',
        description: 'Pesanan #ORD-20231026-001 dari pelanggan Budi telah masuk.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        icon: Icons.shopping_cart,
        iconColor: Colors.green,
      ),
      _ActivityItemData(
        title: 'Produk Baru Ditambahkan',
        description: 'Produk "Kemeja Flanel Pria" berhasil ditambahkan ke katalog.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        icon: Icons.add_box,
        iconColor: Colors.blue,
      ),
      _ActivityItemData(
        title: 'Pembayaran Dikonfirmasi',
        description: 'Pembayaran untuk pesanan #ORD-20231026-002 telah berhasil.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        icon: Icons.payment,
        iconColor: Colors.purple,
      ),
      _ActivityItemData(
        title: 'Stok Produk Menipis',
        description: 'Stok "Celana Jeans Wanita" tersisa 5 unit. Segera restock!',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        icon: Icons.warning,
        iconColor: Colors.orange,
      ),
      _ActivityItemData(
        title: 'Ulasan Produk Baru',
        description: 'Pelanggan memberikan ulasan bintang 5 untuk "Sepatu Sneakers".',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        icon: Icons.star,
        iconColor: Colors.amber,
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _ActivityListItem(
            activity: activity,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        );
      },
    );
  }
}

class _ActivityListItem extends StatelessWidget {
  const _ActivityListItem({
    required this.activity,
    required this.colorScheme,
    required this.textTheme,
  });

  final _ActivityItemData activity;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} menit lalu';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return DateFormat('dd MMM yyyy, HH:mm').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              activity.icon,
              color: activity.iconColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: AppStyles.primaryTitle(textTheme).copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.description,
                    style: AppStyles.secondarySubtitle(textTheme).copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(activity.timestamp),
                    style: AppStyles.secondarySubtitle(textTheme).copyWith(
                      color: colorScheme.outline,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityItemData {
  final String title;
  final String description;
  final DateTime timestamp;
  final IconData icon;
  final Color iconColor;

  _ActivityItemData({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.icon,
    required this.iconColor,
  });
}
