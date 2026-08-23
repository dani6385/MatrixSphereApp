// lib/screens/attendance/widgets/attendance_action_buttons.dart

import 'package:flutter/material.dart';
import 'attendance_action_button_item.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceActionButtons extends StatelessWidget {
  final bool isCheckingLocation;
  final VoidCallback onClockIn;
  final VoidCallback onClockOut;

  const AttendanceActionButtons({
    super.key,
    required this.isCheckingLocation,
    required this.onClockIn,
    required this.onClockOut,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Pilih Tindakan Presensi', style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (isCheckingLocation)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Memeriksa lokasi...'),
                  ],
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: AttendanceActionButtonItem(
                      onPressed: onClockIn,
                      icon: Icons.login,
                      label: 'Absen Masuk',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AttendanceActionButtonItem(
                      onPressed: onClockOut,
                      icon: Icons.logout,
                      label: 'Absen Pulang',
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}