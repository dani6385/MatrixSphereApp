import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:logger/logger.dart';

import '../crads/active_employee_card.dart';
import '../widgets/attendance_actions.dart';
import '../widgets/attendance_button.dart';
import '../widgets/attendance_camera.dart';

final Logger logger = Logger();

class AttendanceContent extends StatefulWidget {
  const AttendanceContent({super.key});

  @override
  State<AttendanceContent> createState() => _AttendanceContentState();
}

class _AttendanceContentState extends State<AttendanceContent> {
  DateTime? _checkInTime;
  DateTime? _checkOutTime;
  XFile? _checkInImage;
  XFile? _checkOutImage;

  late DateTime _currentTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _getTime() {
    if (mounted) {
      setState(() {
        _currentTime = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        ActiveEmployeeCard(
          now: _currentTime,
          employeeName: 'Matrix Admin',
          employeeId: 'ID: EMP-0001 - Administrator',
        ),
        const SizedBox(height: AppSpacing.xxl),
        AttendanceActions(
          checkInTime: _checkInTime,
          checkOutTime: _checkOutTime,
          checkInImage: _checkInImage,
          checkOutImage: _checkOutImage,
        ),
        const Spacer(), // Mendorong tombol ke bawah
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
                          _checkInTime = now;
                          _checkInImage = image;
                          logger.i('Check-in: $now, Image: ${image.path}');
                        } else if (_checkOutTime == null) {
                          _checkOutTime = now;
                          _checkOutImage = image;
                          logger.i('Check-out: $now, Image: ${image.path}');
                        }
                      });
                    } else {
                      logger.w('No image taken.');
                    }
                    Navigator.pop(context);
                  },
                  onControllerCreated: (CameraController? p1) {},
                );
              },
            );
          },
        ),
        const SizedBox(height: AppSpacing.xxl), // Spasi di bawah tombol
      ],
    );
  }
}
