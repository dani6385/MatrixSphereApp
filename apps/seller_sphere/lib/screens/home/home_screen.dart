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
      drawer: SideMenu(
        // 1. Definisikan Header kustom untuk Seller Sphere
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
        // 2. Definisikan item menu dan logikanya
        items: [
          SideMenuItem(
            title: 'Product',
            icon: Icons.store,
            isSelected: true, // Ganti dengan logika state Home Anda
            onTap: () {
              Navigator.of(context).pop(); // Tutup drawer
              context.go('/product'); // Lakukan navigasi
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
          // ... item menu lainnya
        ], selectedRoute: null,
      ),
      endDrawer: SideMenu(
        // 1. Definisikan Header kustom untuk Seller Sphere
        header: const DrawerHeader(
          decoration: BoxDecoration(color: kDarkAppBar),
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
        // 2. Definisikan item menu dan logikanya
        items: [
          SideMenuItem(
            title: 'Edit',
            icon: Icons.store,
            isSelected: true, // Ganti dengan logika state Home Anda
            onTap: () {
              Navigator.of(context).pop(); // Tutup drawer
              context.go('/product'); // Lakukan navigasi
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
          // ... item menu lainnya
        ], selectedRoute: null,
      ),
      body: const HomeBody(), // ... body
    );
  }
}
