import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                username,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Tombol Notifikasi
          _buildIconButtonWithBadge(
            icon: Icons.notifications_outlined,
            badgeColor: Colors.red,
            onPressed: () {},
          ),
          const SizedBox(width: 12),
          // Tombol Keranjang
          _buildIconButtonWithBadge(
            icon: Icons.shopping_cart_outlined,
            badgeColor: Colors.blue,
            badgeCount: 3, // Contoh jumlah item
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildIconButtonWithBadge({
    required IconData icon,
    required Color badgeColor,
    int? badgeCount,
    required VoidCallback onPressed,
  }) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.iconBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, color: AppColors.iconPrimary),
            onPressed: onPressed,
          ),
        ),
        if (badgeCount != null && badgeCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: badgeColor,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Center(
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}