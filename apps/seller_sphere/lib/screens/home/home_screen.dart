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