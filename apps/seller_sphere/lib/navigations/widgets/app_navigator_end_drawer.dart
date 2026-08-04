// lib/navigation/widgets/app_navigator_drawer.dart

import 'package:flutter/material.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';
import '../app_navigation.dart';

class AppNavigatorEndDrawer extends StatelessWidget {
  const AppNavigatorEndDrawer(
      {super.key,
      required void Function(String route) onDrawerItemTap,
      required void Function(int index, String route) onDrawerItemTapAndClose});

  get leading => null;

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: const SizedBox.shrink(),
      items: const [],
      selectedRoute: '',
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: kTransparent,
          ),
          child: Text(
            'Menu Utama',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profil Saya'),
          onTap: () {
            Navigator.pop(context);
            //AppNavigation.pushToProfile(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Pengaturan'),
          onTap: () {
            Navigator.pop(context);
            AppNavigation.pushTosetting(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Attendance'),
          onTap: () {
            Navigator.pop(context);
            AppNavigation.goToTab(context, AppRoutes.attendance);
          },
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: const Text('Sellers'),
          onTap: () {
            Navigator.pop(context);
            AppNavigation.goToTab(context, AppRoutes.sellers);
          },
        ),
        ListTile(
          leading: const Icon(Icons.live_tv),
          title: const Text('Streaming'),
          onTap: () {
            Navigator.pop(context);
            AppNavigation.goToTab(context, AppRoutes.stream);
          },
        ),
        ListTile(
          leading: const Icon(Icons.business_center),
          title: const Text('Management'),
          onTap: () {
            Navigator.pop(context);
            AppNavigation.goToTab(context, AppRoutes.management);
          },
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            Navigator.pop(context);
            AppNavigation.goToTab(context, AppRoutes.home);
          },
        ),
        const Divider(), // Add a divider for visual separation
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('About'),
          onTap: () {
            Navigator.pop(context);
            // Implement navigation to About screen
          },
        ),

        ListTile(
          leading: const Icon(Icons.login),
          title: const Text('Logout (ke Halaman Login)'),
          onTap: () => AppNavigation.goToLogin(context),
        ),
      ],
    );
  }
}
