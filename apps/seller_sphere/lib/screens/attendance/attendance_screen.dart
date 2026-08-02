
import 'package:flutter/material.dart';
import 'components/attendance_app_bar.dart';
import 'components/attendance_drawer.dart';
import 'components/attendance_end_drawer.dart';

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
      body: Center(
        child: Text('Attendance Screen Content'),
      ),
    );
  }
}
