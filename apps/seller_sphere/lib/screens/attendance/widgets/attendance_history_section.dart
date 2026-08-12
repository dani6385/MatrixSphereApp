
// lib/screens/attendance/widgets/attendance_history_section.dart

import 'package:flutter/material.dart';
import 'package:seller_sphere/models/attendance_model.dart';
import 'package:seller_sphere/screens/attendance/widgets/attendance_history_item.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceHistorySection extends StatelessWidget {
  final List<AttendanceRecord> attendanceHistory;

  const AttendanceHistorySection({
    super.key,
    required this.attendanceHistory,
  });

  @override
  Widget build(BuildContext context) {
    if (attendanceHistory.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: context.surfaceContainer.withValues(alpha: 0.5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            children: [
              Icon(
                Icons.event_note_outlined,
                size: 40,
                color: context.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                'Belum Ada Riwayat Presensi',
                style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Lakukan scan wajah untuk memulai perekaman kehadiran harian Anda.',
                style: context.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: attendanceHistory.map((record) => AttendanceHistoryItem(record: record)).toList(),
    );
  }
}