// lib/screens/home/widgets/home_summary_section.dart
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class HomeSummarySection extends StatelessWidget {
  const HomeSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: const [
        SummaryCard(
          icon: Icons.monetization_on_outlined,
          value: 'Rp 1.2Jt',
          label: 'Pendapatan Hari Ini',
          iconColor: AppColors.success,
        ),
        SummaryCard(
          icon: Icons.shopping_cart_outlined,
          value: '12',
          label: 'Pesanan Baru',
          iconColor: AppColors.info,
        ),
      ],
    );
  }
}