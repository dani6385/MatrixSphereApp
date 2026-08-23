import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_navigations/shared_navigations.dart';
import 'bottom_nav_bar.dart';
import 'widgets/app_drawer_items.dart';
import 'widgets/app_end_drawer_items.dart';

class AppNavigator extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigator({super.key, required this.navigationShell});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  // Fungsi untuk memberitahu GoRouter agar berpindah branch/tab
  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.navigationShell,
      drawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          // Panggil fungsi atau list item SideMenuItem yang ada di home_drawer_items.dart
          return getDrawerSideMenuItems(context, currentRoute);
        },
      ),
      endDrawer: SharedProjectDrawer(
        menuBuilder: (context, currentRoute) {
          // Panggil fungsi atau list item SideMenuItem yang ada di home_drawer_items.dart
          return getEndDrawerSideMenuItems(context, currentRoute);
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _onItemTapped,
        navigationShell: widget.navigationShell,
      ),
    );
  }
}