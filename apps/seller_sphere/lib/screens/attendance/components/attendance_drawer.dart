
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
      footer: footer,
      onItemSelected: (item) {
        // Close the drawer
        Navigator.pop(context);
        // Handle navigation based on the selected item
        // For example:
        // if (item.route != null) {
        //   Navigator.pushNamed(context, item.route!);
        // }
      },
    );
  }
  
  Text get header =>
      const Text('Attendance Menu Header'); // Replace with actual header widget
  List<SideMenuItem> get items => [
        SideMenuItem(
          title: 'Dashboard',
          icon: Icons.dashboard,
          route: '/attendance_dashboard', onTap: () {  },
        ),
        SideMenuItem(
          title: 'Reports',
          icon: Icons.bar_chart,
          route: '/attendance_reports', onTap: () {  },
        ),
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          route: '/attendance_settings', onTap: () {  },
        ),
      ]; // Replace with actual menu items
  String get selectedRoute =>
      '/attendance_dashboard'; // Replace with actual selected route logic
  Text get footer =>
      const Text('Attendance Menu Footer'); // Replace with actual footer widget
}
