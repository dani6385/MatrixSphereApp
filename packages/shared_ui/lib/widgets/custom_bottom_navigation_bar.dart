import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<Widget> items; // Diubah dari List<GButton> menjadi List<Widget>
  final Color? activeColor;
  final Color? backgroundColor;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.items,
    this.activeColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan CurvedNavigationBar untuk efek gelombang
    return CurvedNavigationBar(
      index: selectedIndex,
      height: 60.0,
      items: items,
      color: backgroundColor ?? Colors.white,
      buttonBackgroundColor: backgroundColor ?? Colors.white,
      backgroundColor: Colors.transparent, // Latar belakang utama transparan
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 400),
      onTap: onItemTapped,
      letIndexChange: (index) => true,
    );
  }
}