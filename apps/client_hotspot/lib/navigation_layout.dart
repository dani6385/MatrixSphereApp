import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationLayout extends StatelessWidget {
  final Widget child;

  const NavigationLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Akun',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        // Styling untuk membuatnya terlihat bagus
        type: BottomNavigationBarType.fixed, // Penting agar semua label terlihat
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.routerDelegate.currentConfiguration.fullPath;
    if (location.startsWith('/home')) {
      return 0;
    } else if (location.startsWith('/status')) {
      return 1;
    } else if (location.startsWith('/transaksi')) {
      return 2;
    } else if (location.startsWith('/akun')) {
      return 3;
    } else if (location.startsWith('/settings')) {
      return 4;
    } else {
      return 0; // Default ke home
    }
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/status');
        break;
      case 2:
        context.go('/transaksi');
        break;
      case 3:
        context.go('/akun');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }
}
