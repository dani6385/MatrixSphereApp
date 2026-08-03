import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_router.dart'; // Bisa dihapus jika tidak digunakan langsung
import 'package:seller_sphere/navigation/app_routes.dart';

import 'package:shared_ui/shared_ui.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: header(context),
      items: items(context),
      selectedRoute: selectedRoute(context),
      footer: const Text('Seller Sphere v1.0.0'),
    );
  }

  Widget header(BuildContext context) => Text(
        'Seller Sphere',
        style: AppStyles.primaryTitle(Theme.of(context).textTheme),
      );

  String selectedRoute(BuildContext context) {
    final GoRouter router = GoRouter.of(context);
    return router.location;
  }

  List<SideMenuItem> items(BuildContext context) => [
        SideMenuItem(
          title: 'Dashboard',
          icon: Icons.dashboard_rounded,
          route: AppRoutes.home,
          onTap: () {
            _logger.d('Navigating to Dashboard');
            GoRouter.of(context).push(AppRoutes.home);
          },
        ),
        SideMenuItem(
          title: 'Products',
          icon: Icons.inventory_2_rounded,
          route: AppRoutes.publicProduct,
          onTap: () {
            _logger.d('Navigating to Products');
            GoRouter.of(context).push(AppRoutes.publicProduct);
          },
        ),
        // TODO: Aktifkan kembali setelah rute '/orders' dibuat di app_router.dart
        // SideMenuItem(
        //   title: 'Orders',
        //   icon: Icons.receipt_long_rounded,
        //   route: '/orders', // Ganti dengan AppRoutes.orders jika sudah dibuat
        //   onTap: () {
        //     _logger.d('Navigating to Orders');
        //     GoRouter.of(context).push('/orders');
        //   },
        // ),
        // TODO: Aktifkan kembali setelah rute '/customers' dibuat di app_router.dart
        // SideMenuItem(
        //   title: 'Customers',
        //   icon: Icons.people_alt_rounded,
        //   route: '/customers', // Ganti dengan AppRoutes.customers jika sudah dibuat
        //   onTap: () {
        //     _logger.d('Navigating to Customers');
        //     GoRouter.of(context).push('/customers');
        //   },
        // ),
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings_rounded,
          route: AppRoutes.settings,
          onTap: () {
            _logger.d('Navigating to Settings');
            GoRouter.of(context).push(AppRoutes.settings);
          },
        ),
      ];
}
