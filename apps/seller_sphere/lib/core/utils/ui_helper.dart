import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// A utility class for showing common dialogs and UI elements.
class UiHelper {
  /// Shows a dialog for location-related errors.
  ///
  /// Can optionally show a button to open device settings.
  static void showLocationErrorDialog(
    BuildContext context,
    String title,
    String message, {
    bool showSettingsButton = false,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          if (showSettingsButton)
            TextButton(
              onPressed: () {
                Geolocator.openAppSettings();
                Navigator.of(ctx).pop();
              },
              child: const Text('Buka Pengaturan'),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Shows a success dialog after a face scan is complete.
  static void showScanSuccessDialog(
    BuildContext context, {
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
        title: const Text('Absensi Berhasil!', textAlign: TextAlign.center),
        content: Text(message, textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }
}