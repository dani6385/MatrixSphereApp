// lib/screens/widgets/home_end_drawer.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

class HomeEndDrawer extends StatelessWidget {
  const HomeEndDrawer({super.key});

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
              'Ringkasan Cepat',
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
          title: 'Status Sistem',
          icon: Icons.point_of_sale,
          isSelected: true,
          onTap: () {
            Navigator.of(context).pop();
            context.go('/calculator'); // Sesuaikan dengan route tujuanmu
          },
        ),
        SideMenuItem(
          title: 'Simulasi Diskon',
          icon: Icons.discount_outlined,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            context.go('/discount-simulator');
          },
        ),
        SideMenuItem(
          title: 'Pengaturan Pajak',
          icon: Icons.receipt_long_outlined,
          isSelected: false,
          onTap: () {
            Navigator.of(context).pop();
            context.go('/tax-settings');
          },
        ),
      ],
      selectedRoute: null,
    );
  }
}