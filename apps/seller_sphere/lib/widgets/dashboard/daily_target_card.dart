import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';
import 'package:seller_sphere/utils/formatting.dart';

class DailyTargetCard extends StatelessWidget {
  final AppViewModel viewModel;
  final double todaySalesTotal;
  final double targetValue;
  final double targetProgress;
  final int targetPercentage;

  const DailyTargetCard({super.key, 
    required this.viewModel,
    required this.todaySalesTotal,
    required this.targetValue,
    required this.targetProgress,
    required this.targetPercentage,
  });

  String get _motivationText {
    if (todaySalesTotal == 0.0) {
      return "Semangat! Mulai hari ini dengan menambahkan penjualan pertama Anda. Target Anda hari ini adalah ${formatRupiah(targetValue)}.";
    } else if (targetPercentage < 50) {
      return "Anda sudah mencapai $targetPercentage% dari target hari ini. Terus maju, sisa ${formatRupiah(targetValue - todaySalesTotal)} lagi!";
    } else if (targetPercentage < 100) {
      return "Hampir sampai! $targetPercentage% target tercapai. Tambah beberapa transaksi lagi untuk mencapai sukses hari ini!";
    } else {
      return "Luar biasa! Target penjualan hari ini TELAH TERCAPAI ($targetPercentage%). Pertahankan kinerja hebat ini! 🎉";
    }
  }

  void _showTargetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _TargetDialog(initialValue: targetValue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                    Icon(Icons.notifications_active, color: Color(0xFFFFA500), size: 20),
                    SizedBox(width: 8),
                    Text("Target Penjualan Harian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                TextButton(
                  onPressed: () => _showTargetDialog(context),
                  child: const Text("Ubah", style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 12),
            TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: targetProgress),
                duration: const Duration(milliseconds: 800),
                builder: (context, value, child) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
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
              _motivationText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetDialog extends StatefulWidget {
  final double initialValue;
  const _TargetDialog({required this.initialValue});

  @override
  State<_TargetDialog> createState() => _TargetDialogState();
}

class _TargetDialogState extends State<_TargetDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toInt().toString());
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final amount = double.tryParse(_controller.text) ?? 0.0;
    context.read<AppViewModel>().updateTodayTarget(amount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const Text("Atur Target Penjualan Harian", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Target Rp",
          prefixText: "Rp ",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Batal")),
        TextButton(onPressed: _save, child: const Text("Simpan")),
      ],
    );
  }
}
