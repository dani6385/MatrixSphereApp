// lib/screens/widgets/Management_end_drawer.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';

class ManagementEndDrawer extends StatelessWidget {
  const ManagementEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: const DrawerHeader(
        decoration: BoxDecoration(
          color: kAccentBlue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.storefront, color: kBrandPrimary, size: 48),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Kalkulasi',
              style: TextStyle(
                color: kDarkTextPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      items: items(context),
      selectedRoute: selectedRoute(context),
      footer: const Text('Kalkulasi v1.0.0'),
    );
  }

  String selectedRoute(BuildContext context) {
    return GoRouter.of(context).location;
  }

  List<SideMenuItem> items(BuildContext context) => [
        SideMenuItem(
          title: 'Edit',
          icon: Icons.store,
          route: AppRoutes.productDetailEdit,
          onTap: () {
            Navigator.of(context).pop();
            context.go(AppRoutes.productDetailEdit);
          },
        ),
        SideMenuItem(
          title: 'Approval',
          icon: Icons.playlist_add_check,
          route: AppRoutes.managementApproval,
          onTap: () {
            Navigator.of(context).pop();
            context.go(AppRoutes.managementApproval);
          },
        ),
      ];
}