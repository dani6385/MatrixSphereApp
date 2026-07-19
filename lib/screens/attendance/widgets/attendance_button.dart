import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceButton extends StatelessWidget {
  final bool isCheckedIn;
  final bool isCompleted;
  final VoidCallback onPressed;

  const AttendanceButton({
    super.key,
    required this.isCheckedIn,
    required this.isCompleted,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    String buttonLabel = 'Absen Masuk';
    IconData buttonIcon = Icons.fingerprint;
    Color buttonColor = kBrandPrimary;

    if (isCheckedIn && !isCompleted) {
      buttonLabel = 'Absen Pulang';
      buttonIcon = Icons.logout;
      buttonColor = kWarmOrange;
    } else if (isCompleted) {
      buttonLabel = 'Selesai';
      buttonIcon = Icons.check_circle;
      buttonColor = kDarkTextSecondary;
    }

    return ElevatedButton.icon(
      icon: Icon(buttonIcon),
      label: Text(buttonLabel),
      onPressed: isCompleted ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: kDarkTextPrimary,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
