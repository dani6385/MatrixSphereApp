import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/screens/attendance/providers/attendance_viewmodel.dart';
import 'package:shared_ui/shared_ui.dart';

/// A utility class for showing common UI elements like dialogs.
class UiHelper {
  /// Shows a generic error dialog, with an optional button to open app settings.
  static void showLocationErrorDialog(
    BuildContext context,
    String title,
    String content, {
    bool showSettingsButton = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (showSettingsButton)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
              child: const Text("Buka Pengaturan"),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// Shows a success dialog after a successful attendance scan.
  static void showScanSuccessDialog(BuildContext context) {
    // Reads the required message directly from the ViewModel.
    final viewModel = context.read<AttendanceViewModel>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        icon: const Icon(Icons.check_circle, color: kSoftTeal, size: 48),
        title: const Text(
          "Absensi Berhasil!",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          "Verifikasi wajah biometrik Anda valid. ${viewModel.lastRecordedTimeMessage}.\nData presensi Anda telah diunggah ke cloud.",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(backgroundColor: kSoftTeal, foregroundColor: Colors.black),
              child: const Text("Selesai", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }
}