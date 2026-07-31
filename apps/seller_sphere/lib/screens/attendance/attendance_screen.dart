// lib/screens/Attendance_screen.dart

import 'package:flutter/material.dart';

import 'components/Attendance_appbar.dart';
import 'components/Attendance_body.dart';
import 'components/Attendance_drawer.dart';
import 'components/Attendance_end_drawer.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AttendanceAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: AttendanceDrawer(),
      endDrawer: AttendanceEndDrawer(),
      body: AttendanceBody(),
    );
  }
}