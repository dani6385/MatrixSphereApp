// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
import 'components/home_appbar.dart';
import 'components/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),

      // Menonaktifkan gestur geser layar dari tepi
      drawerEnableOpenDragGesture: false,

      // Laci Sisi Kiri (Menu Utama Aplikasi Seller Sphere)
      drawer: SideMenu(
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
        // Menambahkan item menu untuk laci kiri
        items: [
          SideMenuItem(
            title: 'Beranda',
            icon: Icons.home,
            isSelected: true,
            onTap: () {
              Navigator.of(context).pop();
              context.go('/home');
            },
          ),
          SideMenuItem(
            title: 'Inventaris',
            icon: Icons.inventory_2,
            isSelected: false,
            onTap: () {
              Navigator.of(context).pop();
              context.go('/inventory');
            },
          ),
        ],
        selectedRoute: '/home',
      ),

      endDrawerEnableOpenDragGesture: false,
      // Laci Sisi Kanan (Panel Kalkulasi / Filter Tambahan)
      endDrawer: SideMenu(
        header: const DrawerHeader(
          decoration: BoxDecoration(color: kDarkAppBar),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.calculate, color: kBrandPrimary, size: 48),
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
        // Menambahkan item menu untuk laci kanan
        items: [
          SideMenuItem(
            title: 'Edit',
            icon: Icons.store,
            isSelected: false,
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
      ),

      // Isi Utama Halaman Beranda
      body: const HomeBody(),
    );
  }
}
