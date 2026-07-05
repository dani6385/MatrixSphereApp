import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigation extends StatelessWidget {
  const AppNavigation({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.app_registration), label: 'Registration'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: navigationShell.currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// Navigates to the a new branch of the shell route.
  ///
  /// Navigates to the a new branch of the shell route. When the user taps
  /// on the bottom navigation bar item that is already selected, the
  /// initial route of that branch is pushed.
  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // support navigating to the initial location when tapping the item that is
      // already active
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}