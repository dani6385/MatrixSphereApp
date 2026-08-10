// lib/screens/attendance/widgets/attendance_permission_request.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendancePermissionRequest extends StatelessWidget {
  final VoidCallback onRequestPermission;

  const AttendancePermissionRequest({
    super.key,
    required this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videocam_off_outlined,
              size: 48, color: context.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Izin Kamera Dibutuhkan',
            style: context.textTheme.titleMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Aplikasi memerlukan akses ke kamera depan untuk verifikasi wajah biometrik.',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRequestPermission,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Berikan Izin'),
          ),
        ],
      ),
    );
  }
}
