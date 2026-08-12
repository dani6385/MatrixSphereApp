import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:intl/intl.dart'; // Impor untuk format mata uang

class SellerSummarySection extends StatelessWidget {
  const SellerSummarySection({super.key});

  @override
  Widget build(BuildContext context) {

    // Contoh data statis
    const double totalSales = 12500000.0;
    const int totalOrders = 150;
    const int pendingOrders = 12;
    const double revenue = 2500000.0;

    // Format mata uang Rupiah
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ringkasan Penjualan',
          style: AppStyles.headlineSmall.copyWith(
            color: context.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5, // Adjust as needed
          children: [
            _StatCard(
              title: 'Total Penjualan',
              value: currencyFormatter.format(totalSales),
              icon: Icons.attach_money,
              iconColor: Colors.green,
            ),
            _StatCard(
              title: 'Total Pesanan',
              value: totalOrders.toString(),
              icon: Icons.shopping_cart,
              iconColor: Colors.blue,
            ),
            _StatCard(
              title: 'Pesanan Tertunda',
              value: pendingOrders.toString(),
              icon: Icons.pending_actions,
              iconColor: Colors.orange,
            ),
            _StatCard(
              title: 'Pendapatan',
              value: currencyFormatter.format(revenue),
              icon: Icons.bar_chart,
              iconColor: Colors.purple,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppStyles.bodyMedium.copyWith(
                    color: context.onSurfaceVariant,
                  ),
                ),
                Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ],
            ),
            Text(
              value,
              style: AppStyles.headlineMedium.copyWith(
                color: context.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
