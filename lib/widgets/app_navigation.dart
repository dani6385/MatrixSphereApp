import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/theme/app_colors.dart';

class AppNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTapped;

  const AppNavigation({
    super.key,
    required this.currentIndex,
    required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Kontainer untuk menciptakan efek "floating" dan "pill-shaped"
    return Container(
      // Memberi bayangan agar terlihat melayang
      decoration: BoxDecoration(
        color: surface, // Warna latar belakang dari tema
        borderRadius: BorderRadius.circular(50), // Bentuk pil yang sangat melengkung
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      // Margin untuk memberikan ruang di sekitar bilah navigasi
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Padding(
        // Padding di dalam bilah navigasi
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: GNav(
          // Properti utama GNav
          rippleColor: primary.withOpacity(0.1),
          hoverColor: primary.withOpacity(0.05),
          gap: 8, // Jarak antara ikon dan teks
          activeColor: textPrimary, // Warna item yang aktif
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding item
          duration: const Duration(milliseconds: 400), // Durasi animasi
          tabBackgroundColor: primary.withOpacity(0.2), // Latar belakang item aktif
          color: textSecondary, // Warna item yang tidak aktif
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.store, text: 'Seller'),
            GButton(icon: Icons.approval, text: 'Approval'),
            GButton(icon: Icons.computer, text: 'System'), // Mengubah ikon untuk System
            GButton(icon: Icons.settings, text: 'Settings'), // Menambahkan item Settings
          ],
          selectedIndex: currentIndex,
          onTabChange: onTapped,
        ),
      ),
    );
  }
}
