import 'package:flutter/material.dart';
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
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTapped,
      backgroundColor: background,
      selectedItemColor: primary,
      unselectedItemColor: textSecondary,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Seller'),
        BottomNavigationBarItem(icon: Icon(Icons.approval), label: 'Approval'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'System'),
      ],
    );
  }
}
