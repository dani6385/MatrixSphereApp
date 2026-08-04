import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'app_extractor.dart';
//import '../providers/app_viewmodel.dart';
import 'bottom_nav_bar.dart';
import 'widgets/app_navigator_drawer.dart';

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
void _onDrawerItemTap(String route) {
    context.go(route);
  }
  void _onDrawerItemTapAndClose(int index, String route) {
    _onItemTapped(index);
    context.go(route);
    Navigator.of(context).pop(); // Close the drawer
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _onItemTapped,
      ),
      drawer: AppNavigatorDrawer(
        onDrawerItemTap: _onDrawerItemTap,
        onDrawerItemTapAndClose: _onDrawerItemTapAndClose,
      ),
    );
    
  }
}
