// lib/screens/home/widgets/home_quick_actions_grid.dart
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class HomeQuickActionsGrid extends StatelessWidget {
  const HomeQuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        QuickActionChip(icon: Icons.add_box_outlined, label: 'Produk'),
        QuickActionChip(icon: Icons.qr_code_scanner, label: 'Scan'),
        QuickActionChip(icon: Icons.bar_chart_outlined, label: 'Laporan'),
        QuickActionChip(icon: Icons.chat_bubble_outline, label: 'Chat'),
      ],
    );
  }
}