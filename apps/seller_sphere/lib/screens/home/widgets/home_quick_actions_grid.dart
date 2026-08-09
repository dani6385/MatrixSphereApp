// lib/screens/home/widgets/home_quick_actions_grid.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'home_quick_actions_logic.dart';

class HomeQuickActionsGrid extends StatelessWidget {
  HomeQuickActionsGrid({super.key});

  final HomeQuickActionsLogic _logic = HomeQuickActionsLogic();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        QuickActionChip(
          icon: Icons.add_box_outlined,
          label: 'Produk',
          onPressed: () {
            _logic.onProductPressed(context);
          },
        ),
        QuickActionChip(
          icon: Icons.qr_code_scanner,
          label: 'Scan',
          onPressed: () {
            _logic.onScanPressed(context);
          },
        ),
        QuickActionChip(
          icon: Icons.bar_chart_outlined,
          label: 'Laporan',
          // PERBAIKAN: Gunakan kurung kurawal atau panggil langsung tanpa panah yang mengembalikan nilai
          onPressed: () {
            _logic.onReportPressed();
          },
        ),
        QuickActionChip(
          icon: Icons.chat_bubble_outline,
          label: 'Chat',
          onPressed: () {
            _logic.onChatPressed();
          },
        ),
      ],
    );
  }
}