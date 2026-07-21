import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class MonthlyStats extends StatelessWidget {
  const MonthlyStats({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Statistik Bulan Ini',
            style: textTheme.titleMedium?.copyWith(color: kDarkTextPrimary)),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(context,
                count: '2', label: 'Hadir', color: kSoftTeal),
            _buildStatItem(context, count: '1', label: 'Tepat Waktu'),
            _buildStatItem(context,
                count: '1', label: 'Terlambat', color: kWarmOrange),
            _buildStatItem(context, count: '1', label: 'Izin/Sakit'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context,
      {required String count, required String label, Color? color}) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: kDarkSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(count,
              style: textTheme.titleLarge?.copyWith(
                  color: color ?? kDarkTextPrimary,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
        ],
      ),
    );
  }
}
