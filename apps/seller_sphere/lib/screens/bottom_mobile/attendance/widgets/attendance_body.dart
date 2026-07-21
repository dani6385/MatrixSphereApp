// lib/screens/Attendance/widgets/Attendance_body.dart
import 'package:flutter/material.dart';
import '../crads/date_card.dart';
import '../crads/absensi_shortcut_card.dart';
import '../crads/provider_card.dart';
//import '../crads/active_employee_card.dart';
//import '../content/attendance_actions.dart';

class AttendanceBody extends StatelessWidget {
  const AttendanceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: const [
          //SizedBox(height: 16),
          AbsensiShortcutCard(),
          SizedBox(height: 16),
          DateCard(),
          SizedBox(height: 16),
          ProviderCard(),
        ],
      ),
    );
  }
}
