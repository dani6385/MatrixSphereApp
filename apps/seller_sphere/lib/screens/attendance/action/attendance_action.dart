import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceAction extends StatelessWidget {
  final bool isCheckedIn;
  final bool isCheckOutCompleted;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;

  const AttendanceAction({
    super.key,
    required this.isCheckedIn,
    required this.isCheckOutCompleted,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  @override
  Widget build(BuildContext context) {
    // Jika sudah absen pulang, tampilkan pesan selesai
    if (isCheckOutCompleted) {
      return const Card(
        color: kSoftTeal,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Anda sudah menyelesaikan absensi hari ini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: kDarkTextPrimary, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    // Tentukan teks, ikon, warna, dan fungsi berdasarkan status isCheckedIn
    final String text = isCheckedIn ? 'Absen Pulang' : 'Absen Masuk';
    final IconData icon = isCheckedIn ? Icons.logout : Icons.login;
    final Color color = isCheckedIn ? kWarmOrange : kBrandPrimary;
    final VoidCallback onPressed = isCheckedIn ? onCheckOut : onCheckIn;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}