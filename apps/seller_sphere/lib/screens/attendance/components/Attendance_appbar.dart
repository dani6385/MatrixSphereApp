// lib/screens/widgets/Attendance_app_bar.dart

import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
//import 'package:shared_ui/shared_ui.dart';

class AttendanceAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AttendanceAppBar({super.key});

  @override
  State<AttendanceAppBar> createState() => _AttendanceAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AttendanceAppBarState extends State<AttendanceAppBar> {
  // Nilai awal yang terpilih di dropdown

  // Daftar opsi menu yang diminta

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Attendance'),
    );
  }
}