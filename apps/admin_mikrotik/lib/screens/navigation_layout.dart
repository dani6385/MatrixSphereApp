import 'package:flutter/material.dart';
import 'package:shared_assets/shared_assets.dart';
import 'package:shared_ui/shared_ui.dart';
import '../contants/pages_config.dart';

class NavigationLayout extends StatefulWidget {
  const NavigationLayout({super.key});

  @override
  State<NavigationLayout> createState() => _NavigationLayoutState();
}

class _NavigationLayoutState extends State<NavigationLayout> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagesConfig.pages[_selectedIndex],
      bottomNavigationBar: AppBottomNavBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textOnLight,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.wifi), label: "Hotspot"),
          BottomNavigationBarItem(icon: Icon(Icons.sync_alt), label: "Status"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
