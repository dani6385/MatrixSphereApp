import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/models/attendance_record.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceItemRow extends StatelessWidget {
  final AttendanceRecord record;
  const AttendanceItemRow({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final statusColor = record.status == "Hadir"
        ? kSoftTeal
        : record.status == "Terlambat"
            ? const Color(0xFFEAB308)
            : kNeonCyan;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15)),
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon Badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                record.status == "Hadir"
                    ? Icons.verified
                    : record.status == "Terlambat"
                        ? Icons.access_time
                        : Icons.event_available,
                color: statusColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            // Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMMd('id_ID').format(record.date),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text("Masuk: ${record.clockInTime ?? '--:--:--'}",
                          style: const TextStyle(fontSize: 11)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text("•", style: TextStyle(fontSize: 11)),
                      ),
                      Text("Pulang: ${record.clockOutTime ?? '--:--:--'}",
                          style: const TextStyle(fontSize: 11)),
                    ],
                  )
                ],
              ),
            ),
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor),
              ),
              child: Text(
                record.status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}