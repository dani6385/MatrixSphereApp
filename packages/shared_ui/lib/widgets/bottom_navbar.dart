import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withAlpha(1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: GNav(
          rippleColor: theme.colorScheme.primary.withAlpha(2),
          hoverColor: theme.colorScheme.primary.withAlpha(1),
          gap: 8,
          activeColor: theme.colorScheme.onSurface,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: theme.colorScheme.primary.withAlpha(2),
          color: theme.colorScheme.onSurface.withAlpha(6),
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.store, text: 'Seller'),
            GButton(icon: Icons.approval, text: 'Approval'),
            GButton(icon: Icons.computer, text: 'System'),
            GButton(icon: Icons.settings, text: 'Settings'),
          ],
          selectedIndex: currentIndex,
          onTabChange: onTap,
        ),
      ),
    );
  }
}
