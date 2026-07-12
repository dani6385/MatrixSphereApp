
import 'package:flutter/material.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';

class DailyTargetCard extends StatelessWidget {
  final AppViewModel viewModel;
  final double todaySalesTotal;
  final double targetValue;
  final int targetPercentage;
  final double targetProgress;
  final VoidCallback onEdit;

  const DailyTargetCard({
    super.key,
    required this.viewModel,
    required this.todaySalesTotal,
    required this.targetValue,
    required this.targetPercentage,
    required this.targetProgress,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Target Penjualan Hari Ini'),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: targetProgress,
              minHeight: 10,
            ),
            const SizedBox(height: 8),
            Text('$targetPercentage% dari Rp. ${targetValue.toStringAsFixed(0)}'),
          ],
        ),
      ),
    );
  }
}
