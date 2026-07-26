// lib/src/widgets/bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:seller_sphere/navigation/app_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';

/// A custom bottom navigation bar widget that is reusable across the app.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// Indeks tab yang sedang aktif saat ini.
  final int currentIndex;

  /// Fungsi callback saat salah satu tab ditekan.
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    // Data untuk ikon, dipetakan berdasarkan rute
    const Map<String, ({IconData icon, IconData activeIcon})> tabIcons = {
      AppRoutes.home: (icon: Icons.home_outlined, activeIcon: Icons.home),
      AppRoutes.stream: (icon: Icons.cast, activeIcon: Icons.cast_connected),
      AppRoutes.inventory: (
        icon: Icons.point_of_sale,
        activeIcon: Icons.point_of_sale_outlined
      ),
      AppRoutes.sellers: (
        icon: Icons.inventory_2,
        activeIcon: Icons.inventory_2_outlined
      ),
      AppRoutes.attendance: (
        icon: Icons.fingerprint_outlined,
        activeIcon: Icons.fingerprint
      ),
    };

    return Container(
      // Memberikan latar belakang melengkung/warna dasar pada area navigasi bawah
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E2C), // Memberikan warna latar belakang yang solid
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: GNav(
        backgroundColor: kTransparent,
        color: kLightBorder,
        activeColor: kLightTextPrimary,
        // Warna latar item aktif dibuat sedikit lebih terang dari background utama
        tabBackgroundColor: const Color(0xFF2F2F3D),
        gap: 8,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        selectedIndex: currentIndex,
        onTabChange: onTap,
        tabs: List.generate(appShellBranches.length, (index) {
          final isSelected = index == currentIndex;
          final routePath = (appShellBranches[index].routes.first as dynamic).path;
          final icons = tabIcons[routePath]!;
          return GButton(
            icon: isSelected ? icons.activeIcon : icons.icon,
            text: '', // Teks dikosongkan sesuai desain
            iconSize: 26,
          );
        }),
      ),
    );
  }
}
