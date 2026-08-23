import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/shared_ui.dart';

class SharedBottomNavBar extends StatelessWidget {
  final List<GButton> tabs;
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const SharedBottomNavBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Konversi GButton menjadi Icon untuk CurvedNavigationBar
    final items = tabs
        .map((tab) => Icon(tab.icon, size: 20, color: kDarkTextPrimary))
        .toList();

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: kBrandPrimary.withOpacity(0.3),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, -3), // changes position of shadow
          ),
        ],
      ),
      child: CurvedNavigationBar(
        index: selectedIndex,
        height: 65,
        items: items,
        onTap: onItemTapped,
        color: kNeonCyan,
        buttonBackgroundColor: kBrandBlack,// Menggunakan kBrandPrimary
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
