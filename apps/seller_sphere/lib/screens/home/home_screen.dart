// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/navigation/app_routes.dart';

// Impor komponen widget yang sudah dipecah
import 'widgets/home_welcome_header.dart';
import 'widgets/home_summary_section.dart';
import 'widgets/home_quick_actions_grid.dart';
import 'widgets/home_recent_activity_list.dart';
import 'widgets/home_section_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Dasbor Penjual',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, size: 28),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0, left: 8.0),
            child: CircleAvatar(
              backgroundColor: kBrandPrimary,
              child: Text(
                'A',
                style: TextStyle(color: kDarkTextPrimary),
              ),
            ),
          ),
        ],
      ),
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
            isSelected: true, // Ganti dengan logika state management Anda
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
      endDrawer: const SideMenu(
        // 1. Definisikan Header kustom untuk Seller Sphere
        header: DrawerHeader(
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
        ), items: [], selectedRoute: null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          HomeWelcomeHeader(sellerName: 'Andi'),
          SizedBox(height: 24),
          HomeSummarySection(),
          SizedBox(height: 24),
          HomeSectionHeader(title: 'Aksi Cepat'),
          SizedBox(height: 16),
          HomeQuickActionsGrid(),
          SizedBox(height: 24),
          HomeSectionHeader(title: 'Aktivitas Terbaru'),
          SizedBox(height: 16),
          HomeRecentActivityList(),
        ],
      ),
    );
  }
}