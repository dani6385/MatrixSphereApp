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

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: GNav(
          rippleColor: theme.colorScheme.primary.withOpacity(0.1),
          hoverColor: theme.colorScheme.primary.withOpacity(0.05),
          gap: 8,
          activeColor: theme.colorScheme.onSurface,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: theme.colorScheme.primary.withOpacity(0.2),
          color: theme.colorScheme.onSurface.withOpacity(0.6),
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.store, text: 'Seller'),
            GButton(icon: Icons.approval, text: 'Approval'),
            GButton(icon: Icons.computer, text: 'System'),
            GButton(icon: Icons.settings, text: 'Settings'),
          ],
          selectedIndex: currentIndex,
          onTabChange: onTapped,
        ),
      ),
    );
  }
}
