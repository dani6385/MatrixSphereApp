import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
    final theme = Theme.of(context);

    // Container untuk menciptakan efek "floating" dan "pill-shaped"
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // Menggunakan warna dari tema
        borderRadius: BorderRadius.circular(50), // Bentuk pil
        boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withAlpha(1)),
        ],
      ),
      // Margin untuk memberikan ruang di sekitar bilah navigasi
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: GNav(
          rippleColor: theme.colorScheme.primary.withAlpha(1),
          hoverColor: theme.colorScheme.primary.withAlpha(5),
          gap: 8, // Jarak antara ikon dan teks
          activeColor: theme.colorScheme.onSurface, // Warna item yang aktif
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: theme.colorScheme.primary.withAlpha(2),
          color: theme.colorScheme.onSurface.withAlpha(
            6,
          ), // Warna item yang tidak aktif
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.store, text: 'Seller'),
            GButton(icon: Icons.approval, text: 'Approval'),
            GButton(
              icon: Icons.computer,
              text: 'System',
            ), // Mengganti ikon untuk konsistensi
            GButton(
              icon: Icons.settings,
              text: 'Settings',
            ), // Item Settings baru
          ],
          selectedIndex: currentIndex,
          onTabChange: onTapped,
        ),
      ),
    );
  }
}
