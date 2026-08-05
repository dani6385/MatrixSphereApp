// lib/screens/Attendance_screen.dart

import 'package:flutter/material.dart';
import 'components/attendance_appbar.dart';
//import 'components/attendance_body.dart';
import 'components/attendance_drawer.dart';
import 'components/attendance_end_drawer.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Scaffold itself will have a transparent background by default
      appBar: AttendanceAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: AttendanceDrawer(),
      endDrawer: AttendanceEndDrawer(),
      body: Center(
        child: Text(
          'Selamat Datang di Halaman Presensi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
