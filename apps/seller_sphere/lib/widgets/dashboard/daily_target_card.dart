import 'package:flutter/material.dart';
import 'package:seller_sphere/utils/formatting.dart';
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
    final motivationText = getMotivationText();

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.notifications_active, color: Color(0xFFFFA500), size: 20),
                    const SizedBox(width: 8),
                    const Text("Target Penjualan Harian",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                GestureDetector(
                  onTap: onEdit,
                  child: Text(
                    "Ubah",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: targetProgress),
              duration: const Duration(milliseconds: 800),
              builder: (context, value, child) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 16,
                  backgroundColor: const Color(0xFF2E3E66),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFA500)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${formatRupiah(todaySalesTotal)} / ${formatRupiah(targetValue)}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "$targetPercentage%",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: targetPercentage >= 100 ? const Color(0xFF4CAF50) : const Color(0xFFFFA500),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              motivationText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(230), // 0.9 alpha
                    fontSize: 13,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String getMotivationText() {
    if (todaySalesTotal == 0.0) {
      return "Semangat! Mulai hari ini dengan menambahkan penjualan pertama Anda. Target Anda hari ini adalah ${formatRupiah(targetValue)}.";
    } else if (targetPercentage < 50) {
      return "Anda sudah mencapai $targetPercentage% dari target hari ini. Terus maju, sisa ${formatRupiah(targetValue - todaySalesTotal)} lagi!";
    } else if (targetPercentage < 100) {
      return "Hampir sampai! $targetPercentage% target tercapai. Tambah beberapa transaksi lagi untuk mencapai sukses hari ini!";
    } else {
      return "Luar biasa! Target penjualan hari ini TELAH TERCAPAI ($targetPercentage%). Pertahankan kinerja hebat ini! ???";
    }
  }
}
