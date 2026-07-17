import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceLog extends StatelessWidget {
  const AttendanceLog({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Log Kehadiran Karyawan',
                style: textTheme.titleMedium?.copyWith(color: kDarkTextPrimary)),
            const Spacer(),
            Text('8 Catatan',
                style:
                    textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: kDarkSecondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: kDarkBackground,
                child: Icon(Icons.person, color: kDarkTextSecondary),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dewi Fortuna',
                      style:
                          textTheme.bodyLarge?.copyWith(color: kDarkTextPrimary)),
                  Text('Status: Full Day Off Duty',
                      style: textTheme.bodySmall
                          ?.copyWith(color: kDarkTextSecondary)),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2), // Use withOpacity
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('Sakit',
                        style:
                            textTheme.bodySmall?.copyWith(color: kSoftTeal)),
                  ),
                  Text('2026-07-16',
                      style: textTheme.bodySmall
                          ?.copyWith(color: kDarkTextSecondary)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
