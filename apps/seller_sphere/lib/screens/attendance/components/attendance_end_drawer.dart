
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceEndDrawer extends StatelessWidget {  const AttendanceEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SideMenu(      header: header,
      items: items,
      selectedRoute: selectedRoute,
      footer: const Text('Attendance v1.0.0'),
      onItemSelected: (SideMenuItem item) {},
    );
  }

  Widget get header => const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.green, // A distinct color for the attendance drawer
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(Icons.check_circle_outline, size: 40, color: Colors.green),
            ),
            SizedBox(height: 8),
            Text(
              'Attendance Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  List<SideMenuItem> get items => [
        SideMenuItem(
          title: 'Overview',
          icon: Icons.dashboard,
          route: '/attendance_overview',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'Punch In/Out',
          icon: Icons.fingerprint,
          route: '/attendance_punch',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'History',
          icon: Icons.history,
          route: '/attendance_history',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'Reports',
          icon: Icons.bar_chart,
          route: '/attendance_reports',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          route: '/attendance_settings',
          onTap: () {},
        ),
      ];

  String get selectedRoute =>
      '/attendance_overview'; // This should be dynamic based on current route
}
