import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';

import '../providers/attendance_provider.dart';

class MonthlyStats extends StatelessWidget {
  const MonthlyStats({super.key});

  @override
  Widget build(BuildContext context) {
    // Dengarkan perubahan dari AttendanceProvider
    final attendanceProvider = context.watch<AttendanceProvider>();
    final records = attendanceProvider.attendanceRecords;

    return Card(
      color: kDarkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Riwayat Absensi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkTextPrimary),
            ),
            const SizedBox(height: 8),
            const Divider(color: kDarkBorder),
            if (records.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text('Belum ada riwayat absensi.', style: TextStyle(color: kDarkTextSecondary)),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return ListTile(
                    leading: const Icon(Icons.check_circle_outline, color: kSoftTeal),
                    title: Text(DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(record), style: const TextStyle(color: kDarkTextPrimary)),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}