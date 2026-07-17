import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceActions extends StatelessWidget {
  const AttendanceActions({super.key, DateTime? checkInTime, DateTime? checkOutTime, XFile? checkInImage, XFile? checkOutImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _buildActionCard(context,
                icon: Icons.fingerprint,
                title: 'Absen Masuk',
                subtitle: 'Mulai Jam Kerja')),
        const SizedBox(width: AppSpacing.md),
        Expanded(
            child: _buildActionCard(context,
                icon: Icons.exit_to_app,
                title: 'Absen Pulang',
                subtitle: 'Belum Masuk')),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle}) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: kDarkSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: kDarkTextPrimary, size: 24),
          const SizedBox(height: AppSpacing.lg),
          Text(title,
              style: textTheme.titleMedium?.copyWith(color: kDarkTextPrimary)),
          Text(subtitle,
              style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
        ],
      ),
    );
  }
}
