import 'dart:async';
import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_ui/shared_ui.dart';
import 'active_employee_card.dart';
import 'attendance_actions.dart';
import 'general_actions.dart';
import 'monthly_stats.dart';
import 'attendance_log.dart';

class AttendanceContent extends StatefulWidget {
  const AttendanceContent({super.key, DateTime? checkInTime, DateTime? checkOutTime, XFile? checkInImage, XFile? checkOutImage});

  @override
  State<AttendanceContent> createState() => _AttendanceContentState();
}

class _AttendanceContentState extends State<AttendanceContent> {
  late Timer _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // Initialize date formatting for Indonesian locale
    initializeDateFormatting('id_ID', null);
    // Update the time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActiveEmployeeCard(now: _now),
          const SizedBox(height: AppSpacing.lg),
          const AttendanceActions(),
          const SizedBox(height: AppSpacing.md),
          const GeneralActions(),
          const SizedBox(height: AppSpacing.lg),
          const MonthlyStats(),
          const SizedBox(height: AppSpacing.lg),
          const AttendanceLog(),
        ],
      ),
    );
  }
}
