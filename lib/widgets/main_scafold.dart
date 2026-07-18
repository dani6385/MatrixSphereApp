import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:matrix_sphere/routes/app_routes.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // Halaman yang aktif akan ditampilkan di sini
      bottomNavigationBar: Container(
        color: Theme.of(context).scaffoldBackgroundColor, // Sesuaikan dengan tema
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
          child: GNav(
            gap: 8,
            activeColor: Colors.white,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Theme.of(context).primaryColor,
            color: Theme.of(context).iconTheme.color,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.insert_chart, text: 'Seller'),
              GButton(icon: Icons.calendar_today, text: 'Attendance'),
              GButton(icon: Icons.approval, text: 'Approval'),
              GButton(icon: Icons.settings, text: 'Settings'),
            ],
            selectedIndex: _calculateSelectedIndex(context),
            onTabChange: (index) {
              _onItemTapped(index, context);
            },
          ),
        ),
      ),
    );
  }

  // Fungsi untuk menentukan tab mana yang aktif berdasarkan rute saat ini
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.attendance)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.sellers)) {
      return 2;
    }
    if (location.startsWith('/settings')) { // Ganti jika Anda punya route constant
      return 3;
    }
    return 0; // Default ke home
  }

  // Fungsi untuk navigasi saat tab di-tap
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.attendance);
        break;
      case 2:
        context.go(AppRoutes.sellers);
        break;
      case 3:
        context.go('/settings'); // Ganti jika Anda punya route constant
        break;
    }
  }
}
