import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/shared_ui.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<GButton> tabs;
  final Color? activeColor;
  final Color? color;
  final Color? tabBackgroundColor;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.tabs,
    this.activeColor,
    this.color,
    this.tabBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            
            // --- PERUBAHAN UTAMA DI SINI ---
            // Gunakan warna yang diberikan, atau fallback ke warna default.
            activeColor: activeColor ?? Theme.of(context).primaryColor,
            color: color ?? Colors.grey[600],
            tabBackgroundColor: tabBackgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.1),
            // --------------------------------

            tabs: tabs,
            selectedIndex: selectedIndex,
            onTabChange: onItemTapped,
          ),
        ),
      ),
    );
  }
}