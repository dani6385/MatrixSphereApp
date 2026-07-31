// lib/screens/widgets/home_drawer.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: const DrawerHeader(
        decoration: BoxDecoration(color: kDarkAppBar),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.settings, color: kBrandPrimary, size: 48),
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
          isSelected: true,
          onTap: () {
            Navigator.of(context).pop();
            context.go('/product');
          },
        ),
        SideMenuItem(
          title: 'Approval',
          icon: Icons.playlist_add_check,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            context.go('/approval');
          },
        ),
      ],
      selectedRoute: null,
    );
  }
}