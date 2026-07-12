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
      color: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Target Harian Penjualan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                IconButton(icon: Icon(Icons.edit, color: Colors.blue.shade300), onPressed: onEdit),
              ],
            ),
            const SizedBox(height: 8),
            Text('RP ${todaySalesTotal.toStringAsFixed(0)} / RP ${targetValue.toStringAsFixed(0)}', style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: targetProgress,
                    backgroundColor: Colors.grey[800],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade300),
                  ),
                ),
                const SizedBox(width: 8),
                Text('$targetPercentage%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
