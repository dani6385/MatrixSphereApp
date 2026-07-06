import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class HomeAppBar extends StatelessWidget {
  final String username;

  const HomeAppBar({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome,',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                username,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Tombol Notifikasi
          IconBadge(
            icon: Icons.notifications_outlined,
            onPressed: () {},
            badgeCount: 1, // Contoh
          ),
          const SizedBox(width: 12),
          // Tombol Keranjang
          IconBadge(
            icon: Icons.shopping_cart_outlined,
            badgeColor: AppColors.primary,
            badgeCount: 3, // Contoh jumlah item
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}