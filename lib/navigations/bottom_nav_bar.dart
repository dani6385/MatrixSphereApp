import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_navigations/shared_navigations.dart';

/// Custom Bottom Navigation Bar for the main application shell.
///
/// This widget wraps the [SharedBottomNavBar] from the `shared_navigations` package
/// and provides the specific navigation items (tabs) for the application.
class BottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.navigationShell,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Define your navigation bar items here.
    // These items should correspond to the branches defined in app_branches.dart.
    // The order of these GButton items must match the order of StatefulShellBranch
    // in app_branches.dart.
    final List<GButton> tabs = [
      const GButton(
        icon: Icons.home,
        text: 'Home',
      ),
      const GButton(
        icon: Icons.approval,
        text: 'Approvals',
      ),
      const GButton(
        icon: Icons.analytics,
        text: 'Analytics',
      ),
      const GButton(
        icon: Icons.receipt_long,
        text: 'Transactions',
      ),
      const GButton(
        icon: Icons.access_time,
        text: 'Attendance',
      ),
    ];

    return SharedBottomNavBar(
      selectedIndex: currentIndex,
      onTap: onTap,
      tabs: tabs,
    );
  }
}