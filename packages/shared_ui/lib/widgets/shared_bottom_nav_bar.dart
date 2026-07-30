import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

/// A shared, reusable bottom navigation bar with a custom concave (downward-curving) shape.
///
/// This widget is designed to be generic. It receives a list of [GButton]s
/// and does not have any knowledge of the app's specific routes.
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
  // final void Function(int) onItemTapped;.
  final void Function(int) onTap;
  final int selectedIndex;

  /// The list of [GButton] widgets to display as tabs.
  final List<GButton> tabs;

  @override
  Widget build(BuildContext context) {
    // Membuat daftar ikon untuk CurvedNavigationBar.
    // Ikon yang aktif akan menggunakan warna aksen, sedangkan yang lain berwarna netral.
    final items = tabs
        .asMap()
        .entries
        .map((entry) => Icon(entry.value.icon,
            size: 26,
            color: entry.key == selectedIndex
                ? kDarkTextPrimary
                : kDarkTextSecondary.withOpacity(0.8)))
        .toList();

    return ClipPath(
      clipper: _BottomNavClipper(), // Custom clipper for the shape
      child: Container(
        height: 75.0, // Fixed height for the curved shape to be visible
        decoration: const BoxDecoration(
          color: Colors.transparent, // Container luar harus transparan untuk efek clip
        ),
        child: CurvedNavigationBar(
          index: selectedIndex,
          height: 60,
          items: items,
          onTap: onTap,
          color: const Color(0xFF1E1E2C),
          buttonBackgroundColor: const Color(0xFF6C63FF),
          backgroundColor: Colors.transparent, // Latar belakang di balik kurva
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
