import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_ui/shared_ui.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final List<Widget> screens;
  final List<GButton> tabs;
  final int initialSelectedIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.screens,
    required this.tabs,
    this.initialSelectedIndex = 0,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.tabs
        .map((tab) => Icon(tab.icon, size: 24, color: kDarkTextPrimary))
        .toList();

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: widget.screens,
      ),
      bottomNavigationBar: Container(
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
          index: _selectedIndex,
          height: 60,
          items: items,
          onTap: _onItemTapped,
          color: kLightBackground,
          buttonBackgroundColor: kBrandPrimary, // Menggunakan kBrandPrimary
          backgroundColor: kTransparent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 400),
        ),
      ),
    );
  }
}
