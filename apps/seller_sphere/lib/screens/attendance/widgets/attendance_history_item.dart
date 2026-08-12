
import 'package:flutter/material.dart';
import 'package:seller_sphere/models/attendance_model.dart';
import 'package:seller_sphere/screens/attendance/widgets/status_chip.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:intl/intl.dart';

/// A widget that displays a single attendance record in a card.
///
/// It shows the date, clock-in/out times, and a status chip with
/// a corresponding icon and color.
class AttendanceHistoryItem extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceHistoryItem({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    final IconData statusIcon;
    final Color statusColor;

    // Determine icon and color based on the attendance status.
    switch (record.status) {
      case 'Hadir':
        statusIcon = Icons.verified_outlined;
        statusColor = Colors.green;
        break;
      case 'Terlambat':
        statusIcon = Icons.access_time_rounded;
        statusColor = Colors.orange;
        break;
      default:
        statusIcon = Icons.event_available_outlined;
        statusColor = context.primary;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                        .format(record.date),
                    style: context.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Masuk: ${record.clockInTime ?? '--:--'} • Pulang: ${record.clockOutTime ?? '--:--'}',
                    style: context.textTheme.bodySmall
                        ?.copyWith(color: context.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusChip(status: record.status, color: statusColor),
          ],
        ),
      ),
    );
  }
}