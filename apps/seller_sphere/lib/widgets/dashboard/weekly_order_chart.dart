import 'package:flutter/material.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';

class ShopsphereWeeklyOrderChart extends StatelessWidget {
  final List<ShopsphereOrder> orders;
  final AppViewModel viewModel;
  final Function(String) onNavigateToChat;

  const ShopsphereWeeklyOrderChart({
    super.key,
    required this.orders,
    required this.viewModel,
    required this.onNavigateToChat,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Total Pesanan Mingguan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            // This is a placeholder for the chart
            Container(
              height: 200,
              color: Colors.grey[200],
              child: const Center(child: Text('Weekly Order Chart Placeholder')),
            ),
          ],
        ),
      ),
    );
  }
}
