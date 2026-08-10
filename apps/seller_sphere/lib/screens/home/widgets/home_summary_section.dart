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
          title: 'Pendapatan Hari Ini', // Use title for the main text
          color: Colors.green, // Provide a non-null color for the card background
          label: '', // Keep label empty for consistency with sales_screen.dart
          iconColor: Colors.white, // Use white icon for better contrast on colored card
        ),
        SummaryCard(
          icon: Icons.shopping_cart_outlined,
          value: '12',
          title: 'Pesanan Baru', // Use title for the main text
          color: Colors.blue, // Provide a non-null color for the card background
          label: '', // Keep label empty for consistency with sales_screen.dart
          iconColor: Colors.white, // Use white icon for better contrast on colored card
        ),
      ],
    );
  }
}