import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:logger/logger.dart';

import '../widgets/active_employee_card.dart';
import '../widgets/attendance_actions.dart';
import '../widgets/attendance_button.dart';
import '../widgets/attendance_camera.dart';

final Logger logger = Logger();

// Hanya import yang benar-benar digunakan di sini
class AttendanceContent extends StatefulWidget {
  const AttendanceContent({super.key});

  @override
  State<AttendanceContent> createState() => _AttendanceContentState();
}

class _AttendanceContentState extends State<AttendanceContent> {
  // State untuk data absensi
  DateTime? _checkInTime;
  DateTime? _checkOutTime;
  XFile? _checkInImage;
  XFile? _checkOutImage;

  late String _timeString;
  late String _dateString;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id', null);
    _timeString = _formatDateTime(DateTime.now(), 'HH:mm:ss');
    _dateString = _formatDateTime(DateTime.now(), 'EEEE, dd MMMM yyyy');
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        _timeString = _formatDateTime(now, 'HH:mm:ss');
        _dateString = _formatDateTime(now, 'EEEE, dd MMMM yyyy');
      });
    }
  }

  String _formatDateTime(DateTime dateTime, String format) {
    return DateFormat(format, 'id').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Text(
          _timeString,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: kDarkTextPrimary),
        ),
        Text(
          _dateString,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: kDarkTextPrimary),
        ),
        ActiveEmployeeCard(
          employeeName:
              "Budi Santoso", // Anda bisa mengambil data ini dari database/state
          employeeId: "EMP-001", now: DateTime.now(),
        ),
        AttendanceActions(
          checkInTime: _checkInTime,
          checkOutTime: _checkOutTime,
          checkInImage: _checkInImage,
          checkOutImage: _checkOutImage,
        ),
        AttendanceButton(
          isCheckedIn: _checkInTime != null,
          isCompleted: _checkInTime != null && _checkOutTime != null,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return AttendanceCamera(
                  onPictureTaken: (XFile? image) {
                    if (image != null) {
                      setState(() {
                        final now = DateTime.now();
                        if (_checkInTime == null) {
                          // Ini adalah proses Absen Masuk
                          _checkInTime = now;
                          _checkInImage = image;
                          logger.i('Check-in successful at $now with image: ${image.path}');
                        } else if (_checkOutTime == null) {
                          // Ini adalah proses Absen Pulang
                          _checkOutTime = now;
                          _checkOutImage = image;
                          logger.i('Check-out successful at $now with image: ${image.path}');
                        }
                      });
                    } else {
                      logger.w('No image was taken.');
                    }
                    Navigator.pop(context); // Close the bottom sheet
                  }, onControllerCreated: (CameraController? p1) {  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
