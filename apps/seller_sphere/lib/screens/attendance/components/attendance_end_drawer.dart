import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceEndDrawer extends StatelessWidget {
  const AttendanceEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: header,
      items: items(context),
      selectedRoute: selectedRoute(context),
      footer: const Text('Attendance v1.0.0'),
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

  List<SideMenuItem> items(BuildContext context) => [
        /*SideMenuItem(
          title: 'Overview',
          icon: Icons.dashboard,
          route: AppRoutes.attendanceOverview,
          onTap: () {
            Navigator.of(context).pop();
            context.go(AppRoutes.attendanceOverview);
          },
        ),
        SideMenuItem(
          title: 'Punch In/Out',
          icon: Icons.fingerprint,
          route: AppRoutes.attendancePunch,
          onTap: () {
            Navigator.of(context).pop();
            context.go(AppRoutes.attendancePunch);
          },
        ),
        SideMenuItem(
          title: 'History',
          icon: Icons.history,
          route: AppRoutes.attendanceHistory,
          onTap: () {
            Navigator.of(context).pop();
            context.go(AppRoutes.attendanceHistory);
          },
        ),
        SideMenuItem(
          title: 'Reports',
          icon: Icons.bar_chart,
          route: AppRoutes.attendanceReports,
          onTap: () {
            Navigator.of(context).pop();
            context.go(AppRoutes.attendanceReports);
          },
        ),*/
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings,
          route: AppRoutes.settings,
          onTap: () {
            Navigator.of(context).pop();
            context.go(AppRoutes.settings);
          },
        ),
      ];

  String selectedRoute(BuildContext context) => GoRouter.of(context).location;
}
