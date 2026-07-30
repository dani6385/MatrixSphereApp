
import 'package:flutter/material.dart';
import '../widgets/home_welcome_header.dart';
import '../widgets/home_summary_section.dart';
import '../widgets/home_quick_actions_grid.dart';
import '../widgets/home_recent_activity_list.dart';
import '../widgets/home_section_header.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
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
    );
  }
}