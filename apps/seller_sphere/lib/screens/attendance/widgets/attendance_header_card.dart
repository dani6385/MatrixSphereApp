import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/providers/app_viewmodel.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceHeaderCard extends StatelessWidget {
  const AttendanceHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ownerName = context.watch<AppViewModel>().ownerName;
    

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: context.surfaceContainerHighest.withValues(alpha: 0.4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.fingerprint_rounded,
              size: 48,
              color: context.primary,
            ),
            const SizedBox(height: 12),
            Text(
              'Presensi Biometrik Wajah',
              style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Halo, $ownerName! Silakan lakukan absensi kehadiran harian Anda.',
              style: context.textTheme.bodyMedium?.copyWith(color: context.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}