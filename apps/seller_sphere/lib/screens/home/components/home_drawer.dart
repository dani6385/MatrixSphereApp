import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_router.dart';
//import 'package:seller_sphere/navigation/app_routes.dart';

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
          route: '/', // Assuming AppRoutes.home maps to '/'
          onTap: () {
            _logger.d('Navigating to Dashboard');
            GoRouter.of(context).go('/'); // Assuming AppRoutes.home maps to '/'
          },
        ),
        SideMenuItem(
          title: 'Products',
          icon: Icons.inventory_2_rounded,
          route: '/products',
          onTap: () {
            _logger.d('Navigating to Products');
            GoRouter.of(context).go('/products');
          },
        ),
        SideMenuItem(
          title: 'Orders',
          icon: Icons.receipt_long_rounded,
          route: '/orders',
          onTap: () {
            _logger.d('Navigating to Orders');
            GoRouter.of(context).go('/orders');
          },
        ),
        SideMenuItem(
          title: 'Customers',
          icon: Icons.people_alt_rounded,
          route: '/customers',
          onTap: () {
            _logger.d('Navigating to Customers');
            GoRouter.of(context).go('/customers');
          },
        ),
        SideMenuItem(
          title: 'Settings',
          icon: Icons.settings_rounded,
          route: '/settings',
          onTap: () {
            _logger.d('Navigating to Settings');
            GoRouter.of(context).go('/settings');
          },
        ),
      ];
}
