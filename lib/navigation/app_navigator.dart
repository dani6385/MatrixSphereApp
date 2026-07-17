import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:shared_ui/shared_ui.dart'; // Untuk kBrandPrimary, dll.

class AppNavigator extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigator({super.key, required this.navigationShell});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  void _onItemTapped(int index) {
    widget.navigationShell.goBranch(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.navigationShell, // Ini adalah IndexedStack dari go_router
      bottomNavigationBar: CurvedNavigationBar(
        index: widget.navigationShell.currentIndex,
        height: 60,
        items: const <Widget>[
          Icon(Icons.home, size: 24, color: kDarkTextPrimary),
          Icon(Icons.business, size: 24, color: kDarkTextPrimary),
          Icon(Icons.check_circle_outline, size: 24, color: kDarkTextPrimary),
          Icon(Icons.system_update, size: 24, color: kDarkTextPrimary),
          Icon(Icons.fingerprint, size: 24, color: kDarkTextPrimary),
        ],
        onTap: _onItemTapped,
        color: kDarkBackground,
        buttonBackgroundColor: kBrandPrimary,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
