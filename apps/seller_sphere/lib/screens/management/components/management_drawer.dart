// lib/screens/widgets/Management_drawer.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';

class ManagementDrawer extends StatelessWidget {
  const ManagementDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Dapatkan path rute saat ini dari GoRouter
    final String currentRoute = GoRouterState.of(context).uri.toString();

    return SideMenu(
      header: const DrawerHeader(
        decoration: BoxDecoration(color: kDarkAppBar),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.storefront, color: kBrandPrimary, size: 48),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Seller Sphere',
              style: TextStyle(
                color: kDarkTextPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      items: [
        SideMenuItem(
          title: 'Product',
          icon: Icons.store,
          isSelected: currentRoute.startsWith(AppRoutes.product),
          onTap: () {
            Navigator.of(context).pop();
            context.go(AppRoutes.product);
          },
        ),
        SideMenuItem(
          title: 'Approval',
          icon: Icons.playlist_add_check,
          isSelected: currentRoute.startsWith(AppRoutes.approval),
          onTap: () {
            Navigator.of(context).pop();
            context.go(AppRoutes.approval);
          },
        ),
      ],
      selectedRoute: currentRoute,
    );
  }
}