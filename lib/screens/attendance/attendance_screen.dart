import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'widgets/attendance_app_bar.dart';
import 'widgets/attendance_content.dart';
import 'widgets/menu_modal.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: const AttendanceAppBar(),
      drawer: const MenuModel(),
      body: const AttendanceContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kDarkTextPrimary,
        foregroundColor: kDarkBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
