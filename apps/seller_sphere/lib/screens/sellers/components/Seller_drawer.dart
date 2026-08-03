// lib/screens/widgets/Seller_drawer.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

class SellerDrawer extends StatelessWidget {
  const SellerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
              // Menggunakan gaya teks konsisten jika diinginkan
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
          }, route: '',
        ),
        SideMenuItem(
          title: 'Approval',
          icon: Icons.playlist_add_check,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            context.go('/approval');
          }, route: '',
        ),
      ],
      selectedRoute: '',
    );
  }
}