import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';
import 'widgets/account_menu_content.dart';
import 'widgets/attendance_app_bar.dart';
import 'widgets/attendance_button.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime? _checkInTime;
  DateTime? _checkOutTime;

  // Fungsi untuk memformat DateTime menjadi string jam (HH:mm:ss)
  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return DateFormat('HH:mm:ss').format(time);
  }

  void _handleAttendance() { 
    setState(() {
      if (_checkInTime == null) {
        // Aksi saat menekan tombol "Absen Masuk"
        _checkInTime = DateTime.now();
      } else {
        _checkOutTime ??= DateTime.now();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tentukan status tombol berdasarkan state waktu
    final bool isCheckedIn = _checkInTime != null;
    final bool isCompleted = _checkOutTime != null;

    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: const AttendanceAppBar(),
      drawer: const Drawer(
        child: AccountMenuContent(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card untuk menampilkan waktu
            Card(
              color: kDarkSurface,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTimeDisplay('Masuk', _formatTime(_checkInTime)),
                    _buildTimeDisplay('Pulang', _formatTime(_checkOutTime)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Menggunakan widget AttendanceButton yang sudah dipisahkan
            AttendanceButton(
              isCheckedIn: isCheckedIn,
              isCompleted: isCompleted,
              onPressed: _handleAttendance,
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk menampilkan jam
  Widget _buildTimeDisplay(String label, String time) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: kDarkTextSecondary, fontSize: 16)),
        const SizedBox(height: AppSpacing.xs),
        Text(time, style: const TextStyle(color: kDarkTextPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
