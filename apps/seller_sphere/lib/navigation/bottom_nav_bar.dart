import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/shared_ui.dart';

/// A custom bottom navigation bar widget that is reusable across the app.
///
/// It takes the current index and an onTap callback to handle navigation.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// The index of the currently active tab.
  final int currentIndex;

  /// The callback function that is executed when a tab is tapped.
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return SharedBottomNavigationBar(
      selectedIndex: currentIndex,
      onItemTapped: onTap,
      tabs: const [
        GButton(
          icon: Icons.home_outlined,
          text: 'Home',
        ),
        GButton(
          icon: Icons.cast,
          text: 'Streaming',
        ),
        GButton(
          icon: Icons.inventory_2_outlined,
          text: 'Inventory',
        ),
        GButton(
          icon: Icons.chat_bubble_outline,
          text: 'Kios',
        ),
        GButton(
          icon: Icons.store_outlined,
          text: 'Sellers',
        ),
      ],
    );
  }
}