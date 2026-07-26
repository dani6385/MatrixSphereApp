import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/theme/app_colors.dart';

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
  });

  /// The index of the currently active tab.
  final int currentIndex;

  /// The callback function when a tab is tapped.
  final void Function(int) onTap;

  /// The list of [GButton] widgets to display as tabs.
  final List<GButton> tabs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipPath(
      clipper: _BottomNavClipper(), // Custom clipper for the shape
      child: Container(
        height: 80.0, // Fixed height for the curved shape to be visible
        decoration: BoxDecoration(
          color: theme.colorScheme.surface, // Use color from the app's theme
        ),
        child: GNav(
          backgroundColor: kTransparent,
          color: theme.colorScheme.onSurface.withOpacity(0.6), // Inactive icon color
          activeColor: theme.colorScheme.onSurface, // Active icon color
          tabBackgroundColor: theme.colorScheme.onSurface.withOpacity(0.08), // Tab background on selection
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          selectedIndex: currentIndex,
          onTabChange: onTap,
          tabs: tabs, // Use the provided tabs
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