// lib/screens/widgets/Seller_end_drawer.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

class SellerEndDrawer extends StatelessWidget {
  const SellerEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: const DrawerHeader(
        // Menggunakan warna latar belakang AppBar dari konstanta yang konsisten
        decoration: BoxDecoration(color: kDarkAppBar),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.storefront, color: kBrandPrimary, size: 48),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Kalkulasi',
              // Menggunakan gaya teks dengan warna primer terang
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
          title: 'Edit',
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