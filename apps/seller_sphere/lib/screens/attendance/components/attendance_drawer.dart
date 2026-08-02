import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceDrawer extends StatelessWidget {
  const AttendanceDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: header,
      items: items,
      selectedRoute: selectedRoute,
      footer: const Text('Attendance Sphere v1.0.0'),
      onItemSelected: (SideMenuItem item) {},
    );
  }

  Widget get header => const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue, // A distinct color for the Attendance drawer
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(Icons.store, size: 40, color: Colors.blue),
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
          title: 'Dashboard',
          icon: Icons.dashboard,
          route: '/Attendance_dashboard',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'Products',
          icon: Icons.inventory_2,
          route: '/Attendance_products',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'Orders',
          icon: Icons.shopping_cart,
          route: '/Attendance_orders',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'Analytics',
          icon: Icons.analytics,
          route: '/Attendance_analytics',
          onTap: () {},
        ),
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          route: '/Attendance_settings',
          onTap: () {},
        ),
      ];

  String get selectedRoute =>
      '/Attendance_dashboard'; // This should be dynamic based on current route
}
