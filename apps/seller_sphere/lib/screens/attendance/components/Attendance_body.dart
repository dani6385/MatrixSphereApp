
import 'package:flutter/material.dart';
//import '../widgets/attendance_welcome_header.dart';
//import '../widgets/attendance_summary_section.dart';
//import '../widgets/attendance_quick_actions_grid.dart';
//import '../widgets/attendance_recent_activity_list.dart';
//import '../widgets/attendance_section_header.dart';

class AttendanceBody extends StatelessWidget {
  const AttendanceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        //AttendanceWelcomeHeader(sellerName: 'Andi'),
        SizedBox(height: 24),
        //AttendanceSummarySection(),
        SizedBox(height: 24),
        //AttendanceSectionHeader(title: 'Aksi Cepat'),
        SizedBox(height: 16),
        //AttendanceQuickActionsGrid(),
        SizedBox(height: 24),
        //AttendanceSectionHeader(title: 'Aktivitas Terbaru'),
        SizedBox(height: 16),
        //AttendanceRecentActivityList(),
      ],
    );
  }
}