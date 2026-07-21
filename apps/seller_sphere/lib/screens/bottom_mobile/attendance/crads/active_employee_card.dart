import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';

import '../content/employee_time_display.dart'; // Mengimpor widget yang akan digunakan

class ActiveEmployeeCard extends StatelessWidget {
  final DateTime now;
  final String employeeName;
  final String employeeId;

  const ActiveEmployeeCard({
    super.key,
    required this.now,
    required this.employeeName,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final timeFormatter = DateFormat('HH:mm:ss');
    final dateFormatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppStyles.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Karyawan Aktif',
            style: AppStyles.cardHeader(textTheme),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employeeName,
                    style: AppStyles.primaryTitle(textTheme),
                  ),
                  Text(
                    employeeId,
                    style: AppStyles.secondarySubtitle(textTheme),
                  ),
                ],
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () {},
                style: AppStyles.outlinedButtonStyle,
                child: const Text('Bukan Anda?'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Mengganti container manual dengan widget EmployeeTimeDisplay
          EmployeeTimeDisplay(
            // Menggunakan tanggal sebagai label dan waktu sebagai time
            label: dateFormatter.format(now),
            time: timeFormatter.format(now),
          ),
        ],
      ),
    );
  }
}
