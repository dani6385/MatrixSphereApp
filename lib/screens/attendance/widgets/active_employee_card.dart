import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';

class ActiveEmployeeCard extends StatelessWidget {
  final DateTime now;

  const ActiveEmployeeCard({super.key, required this.now, required String employeeName, required String employeeId});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Formatter for time (HH:mm:ss)
    final timeFormatter = DateFormat('HH:mm:ss');
    // Formatter for date (Day, DD MMMM YYYY) in Indonesian
    final dateFormatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: kDarkSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Karyawan Aktif',
              style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Matrix Admin',
                      style: textTheme.titleMedium
                          ?.copyWith(color: kDarkTextPrimary)),
                  Text('ID: EMP-0001 - Administrator',
                      style: textTheme.bodySmall
                          ?.copyWith(color: kDarkTextSecondary)),
                ],
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: kDarkTextPrimary,
                  side: const BorderSide(color: kDarkTextSecondary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Bukan Admin?'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: kDarkBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    timeFormatter.format(now),
                    style: textTheme.displaySmall?.copyWith(
                        color: kDarkTextPrimary, fontWeight: FontWeight.bold),
                  ),
                  Text(dateFormatter.format(now),
                      style: textTheme.bodyMedium
                          ?.copyWith(color: kDarkTextSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
