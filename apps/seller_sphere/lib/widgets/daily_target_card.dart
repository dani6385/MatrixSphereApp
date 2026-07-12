import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color warmOrange = Color(0xFFFFA726);
const Color softTeal = Color(0xFF4DB6AC);
const Color surfaceVariantColor = Color(0xFF1B263B);

class DailyTargetCard extends StatelessWidget {
  final double todaySalesTotal;
  final double todayTarget;
  final VoidCallback onEditTarget;

  const DailyTargetCard({
    super.key,
    required this.todaySalesTotal,
    required this.todayTarget,
    required this.onEditTarget,
  });

  String _formatRupiah(double amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final progress = (todaySalesTotal / (todayTarget > 0 ? todayTarget : 1)).clamp(0.0, 1.0);
    final percentage = (progress * 100).toInt();

    String motivationText;
    if (todaySalesTotal == 0.0) {
      motivationText = "Semangat! Mulai hari ini dengan menambahkan penjualan pertama Anda. Target Anda hari ini adalah ${_formatRupiah(todayTarget)}.";
    } else if (percentage < 50) {
      motivationText = "Anda sudah mencapai $percentage% dari target hari ini. Terus maju, sisa ${_formatRupiah(todayTarget - todaySalesTotal)} lagi!";
    } else if (percentage < 100) {
      motivationText = "Hampir sampai! $percentage% target tercapai. Tambah beberapa transaksi lagi untuk mencapai sukses hari ini!";
    } else {
      motivationText = "Luar biasa! Target penjualan hari ini TELAH TERCAPAI ($percentage%). Pertahankan kinerja hebat ini! 🎉";
    }

    return Card(
      color: surfaceVariantColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.notifications_active, color: warmOrange, size: 20),
                    SizedBox(width: 8),
                    Text("Target Penjualan Harian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                GestureDetector(
                  onTap: onEditTarget,
                  child: Text(
                    "Ubah",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 16,
                backgroundColor: const Color(0xFF2E3E66),
                valueColor: const AlwaysStoppedAnimation<Color>(warmOrange),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${_formatRupiah(todaySalesTotal)} / ${_formatRupiah(todayTarget)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text("$percentage%", style: TextStyle(fontWeight: FontWeight.bold, color: percentage >= 100 ? softTeal : warmOrange, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              motivationText,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
