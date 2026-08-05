// lib/screens/sellers/components/seller_body.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart'; // Impor AppStyles
import '../widgets/seller_welcome_header.dart';
import '../widgets/seller_summary_section.dart';
import '../widgets/seller_quick_actions_grid.dart';
import '../widgets/seller_recent_activity_list.dart';
import '../widgets/seller_section_header.dart';

class SellerBody extends StatelessWidget {
  const SellerBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      // Menerapkan padding standar terpusat dari AppStyles
      padding: AppStyles.defaultScreenPadding,
      physics: const AlwaysScrollableScrollPhysics(),
      children: const [
        SellerWelcomeHeader(sellerName: 'Andi'),
        SizedBox(height: 24),
        SellerSummarySection(),
        SizedBox(height: 24),
        SellerSectionHeader(title: 'Aksi Cepat'),
        SizedBox(height: 16),
        SellerQuickActionsGrid(),
        SizedBox(height: 24),
        SellerSectionHeader(title: 'Aktivitas Terbaru'),
        SizedBox(height: 16),
        SellerRecentActivityList(),
      ],
    );
  }
}

