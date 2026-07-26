// lib/src/widgets/bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
    // Daftar data ikon dan label untuk setiap tab navigasi
    final List<Map<String, dynamic>> tabsData = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'text': ''},
      {'icon': Icons.cast, 'activeIcon': Icons.cast_connected, 'text': ''},
      {'icon': Icons.point_of_sale, 'activeIcon': Icons.point_of_sale_outlined, 'text': ''},
      {'icon': Icons.inventory_2, 'activeIcon': Icons.inventory_2_outlined, 'text': ''},
      {'icon': Icons.fingerprint_outlined, 'activeIcon': Icons.fingerprint, 'text': ''},
    ];

    return Container(
      // Memberikan latar belakang melengkung/warna dasar pada area navigasi bawah
      decoration: const BoxDecoration(
        color: kTransparent, // Sesuaikan dengan warna cyan/biru utama aplikasi
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
        tabBackgroundColor: const Color(0xFF1E1E2C), // Warna latar gelap untuk item aktif melengkung
        gap: 8,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        selectedIndex: currentIndex,
        onTabChange: onTap,
        tabs: List.generate(tabsData.length, (index) {
          final isSelected = index == currentIndex;
          final tab = tabsData[index];
          return GButton(
            icon: isSelected ? tab['activeIcon'] : tab['icon'],
            text: tab['text'],
            iconSize: 26,
          );
        }),
      ),
    );
  }
}