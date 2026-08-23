
// lib/screens/attendance/widgets/attendance_body.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_models/shared_models.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceBody extends StatelessWidget {
  final bool isScanning;
  final bool hasCameraPermission;
  final bool isCheckingLocation;
  final CameraController? cameraController;
  final Animation<double> laserAnimation;
  final String scanStatusMessage;
  final double scanProgress;
  final VoidCallback onCancelScan;
  final VoidCallback onRequestPermission;
  final VoidCallback onClockIn;
  final VoidCallback onClockOut;
  final List<AttendanceRecord> attendanceHistory;
  final VoidCallback onSync;

  const AttendanceBody({
    super.key,
    required this.isScanning,
    required this.hasCameraPermission,
    required this.isCheckingLocation,
    this.cameraController,
    required this.laserAnimation,
    required this.scanStatusMessage,
    required this.scanProgress,
    required this.onCancelScan,
    required this.onRequestPermission,
    required this.onClockIn,
    required this.onClockOut,
    required this.attendanceHistory,
    required this.onSync, required Future<void> Function() onOfficeClockIn, required Future<void> Function() onOfficeClockOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.surface,
            context.surfaceContainerHighest.withValues(alpha: 0.3),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const AttendanceHeaderCard(),
          const SizedBox(height: 16),
          isScanning
              ? AttendanceScannerWidget(
                  isScanning: isScanning,
                  hasCameraPermission: hasCameraPermission,
                  cameraController: cameraController,
                  laserAnimation: laserAnimation,
                  scanStatusMessage: scanStatusMessage,
                  scanProgress: scanProgress,
                  onCancelScan: onCancelScan,
                  onRequestPermission: onRequestPermission,
                )
              : AttendanceActionButtons(
                  isCheckingLocation: isCheckingLocation,
                  onClockIn: onClockIn,
                  onClockOut: onClockOut,
                ),
          const SizedBox(height: 24),
          AttendanceHistoryHeader(onSync: onSync),
          const SizedBox(height: 8),
          AttendanceHistorySection(attendanceHistory: attendanceHistory),
        ],
      ),
    );
  }

}