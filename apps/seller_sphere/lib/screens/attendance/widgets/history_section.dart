import 'package:flutter/material.dart';
import 'package:seller_sphere/models/attendance_record.dart';
import 'package:seller_sphere/screens/attendance/widgets/attendance_item_row.dart';
import 'package:seller_sphere/screens/attendance/widgets/empty_history_card.dart';
import 'package:shared_ui/shared_ui.dart';

class HistorySection extends StatelessWidget {
  final List<AttendanceRecord> records;
  const HistorySection({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    final sortedRecords = List<AttendanceRecord>.from(records)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Riwayat Absensi Kehadiran",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Sinkronisasi data..."),
                  backgroundColor: kNeonCyan,
                ));
              },
              icon: const Icon(Icons.cloud_sync, color: kNeonCyan),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (records.isEmpty)
          const EmptyHistoryCard()
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedRecords.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return AttendanceItemRow(record: sortedRecords[index]);
            },
          ),
      ],
    );
  }
}