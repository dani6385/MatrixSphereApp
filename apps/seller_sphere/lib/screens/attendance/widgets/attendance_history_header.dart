
// lib/screens/attendance/widgets/attendance_history_header.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceHistoryHeader extends StatelessWidget {
  final VoidCallback onSync;

  const AttendanceHistoryHeader({
    super.key,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Riwayat Absensi Kehadiran',
          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: onSync,
          icon: Icon(Icons.cloud_sync_outlined, color: context.primary),
          tooltip: 'Sinkronisasi Data',
        ),
      ],
    );
  }
}