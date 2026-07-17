import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'widgets/account_menu_content.dart';
import 'widgets/attendance_app_bar.dart';
import 'widgets/attendance_content.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AttendanceAppBar(),
      drawer: Drawer(
        child: AccountMenuContent(),
      ),
      body: AttendanceContent(),
    );
  }
}
