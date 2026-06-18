import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items, required Color selectedItemColor, required Color unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    // Widget ini secara otomatis akan mengambil gaya dari
    // BottomNavigationBarThemeData yang telah kita definisikan di app_theme.dart
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: items,
    );
  }
}
