import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart'; // Impor komponen dari shared_ui

class AppNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final List<AppTabItem> tabs;

  const AppNavigation({
    required this.navigationShell,
    required this.tabs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      // Panggil komponen dari shared_ui di sini
      bottomNavigationBar: AppBottomNav(
        navigationShell: navigationShell,
        tabs: tabs, // Gunakan daftar tab yang dilewatkan dari parameter
      ),
    );
  }
}
