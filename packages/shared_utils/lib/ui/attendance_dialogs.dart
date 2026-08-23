import 'package:flutter/material.dart';

class AttendanceDialogs {
  static void showSuccess({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Absensi Berhasil"),
          content: const Text("Wajah dan lokasi Anda telah tervalidasi dengan benar."),
          actions: [
            TextButton(
              onPressed: onConfirm,
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}