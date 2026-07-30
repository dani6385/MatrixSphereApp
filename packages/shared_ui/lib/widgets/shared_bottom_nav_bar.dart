// lib/widgets/shared_bottom_nav_bar.dart

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

/// A shared, reusable bottom navigation bar with a custom concave (downward-curving) shape
/// and a modern aesthetic color palette.
class SharedBottomNavBar extends StatelessWidget {
  const SharedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.tabs,
    required this.selectedIndex,
  });

  /// The index of the currently active tab.
  final int currentIndex;

  /// The callback function when a tab is tapped
  final void Function(int) onTap;
  final int selectedIndex;

  /// The list of [GButton] widgets to display as tabs.
  final List<BottomNavigationBarItem> tabs;

  @override
  Widget build(BuildContext context) {
    // PERBAIKAN: Langsung gunakan widget ikon dari `tabs`.
    // Properti `icon` dari BottomNavigationBarItem sudah merupakan sebuah Widget.
    // Kita tidak perlu membuat ulang Icon atau melakukan casting ke IconData.
    final items = tabs.map((tab) => tab.icon).toList();

    return ClipPath(
      clipper: _BottomNavClipper(),
      child: Container(
        height: 75.0,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: CurvedNavigationBar(
          index: selectedIndex,
          height: 60,
          items: items,
          onTap: onTap,
          // Sentuhan warna kekinian: Latar bar menggunakan nuansa gelap modern (Dark Slate / Charcoal)
          color: const Color(0xFF1E1E2C), 
          // Tombol aktif diberikan aksen warna cerah bernuansa neon modern (Electric Indigo / Vibrant Violet)
          buttonBackgroundColor: const Color(0xFF6C63FF), 
          // Area luar transparan agar lekukan clipper terlihat rapi
          backgroundColor: Colors.transparent, 
          animationCurve: Curves.easeInOutCubic,
          animationDuration: const Duration(milliseconds: 450),
        ),
      ),
    );
  }
}

/// CustomClipper to create a downward-curving bottom navigation shape.
class _BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double curveDepth = 20.0;

    path.moveTo(0, curveDepth);
    path.quadraticBezierTo(size.width / 2, 0, size.width, curveDepth);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
