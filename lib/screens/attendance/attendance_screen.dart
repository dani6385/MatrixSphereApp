import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'crads/attendance_app_bar.dart';
import 'content/attendance_content.dart'; // Import widget utama yang baru kita buat

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AttendanceAppBar(), // Komponen header Anda
      body: AttendanceContent(),  // Semua isi halaman ada di sini
    );
  }
}