import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/shared_ui.dart';

/// A shared, reusable bottom navigation bar with a custom concave (downward-curving) shape.
///
/// This widget is designed to be generic. It receives a list of [GButton]s
/// and does not have any knowledge of the app's specific routes.
class SharedBottomNavBar extends StatelessWidget {
  const SharedBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.tabs,
  });

  /// The index of the currently active tab.
  final int selectedIndex;

  /// The callback function when a tab is tapped
  final void Function(int) onTap;

  /// The list of [GButton] widgets to display as tabs.
  final List<GButton> tabs;

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final items = tabs
        .map((tab) => Icon(tab.icon, size: 20, color: kDarkTextPrimary))
        .toList();

    return ClipPath(
      clipper: _BottomNavClipper(), // Custom clipper for the shape
      child: Container(
        height: 75.0, // Fixed height for the curved shape to be visible
        decoration: const BoxDecoration(
            // Menggunakan const karena warna transparan
            color: kTransparent // Membuat Container terluar transparan
            ),
        child: CurvedNavigationBar(
          index: selectedIndex,
          height: 50,
          items: items,
          onTap: onTap,
          color:
              kNeonCyan, // Membuat CurvedNavigationBar itu sendiri transparan
          buttonBackgroundColor: kDarkDivider, // Menggunakan kBrandPrimary
          backgroundColor: Colors
              .transparent, // Memastikan area di belakang CurvedNavigationBar juga transparan
          animationCurve: Curves.easeIn,
          animationDuration: const Duration(milliseconds: 400),
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
