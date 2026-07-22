import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/shared_ui.dart';

/// A custom bottom navigation bar designed to integrate with a router like GoRouter.
///
/// This widget is "dumb" or "state-less" in the sense that it does not manage
/// its own selected index. It receives the [selectedIndex] from its parent
/// and uses the [onItemTapped] callback to notify the parent when an item is tapped.
class CustomBottomNavigationBar extends StatelessWidget {
  final List<GButton> tabs;
  final int selectedIndex;
  final void Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    // Map the GButton tabs to a list of Icon widgets for CurvedNavigationBar
    final items = tabs
        .map((tab) => Icon(tab.icon, size: 24, color: kDarkTextPrimary))
        .toList();

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: kBrandPrimary.withValues(alpha: 0.3),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, -3), // changes position of shadow
          ),
        ],
      ),
      child: CurvedNavigationBar(
        index: selectedIndex,
        height: 60,
        items: items,
        onTap: onItemTapped,
        color: kVividOrchid,
        buttonBackgroundColor: kDarkSecondary,
        backgroundColor: kDarkDivider,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
