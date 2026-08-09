// lib/screens/attendance/widgets/attendance_scanner_widget.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/attendance/widgets/attendance_active_scanner.dart';
import 'package:seller_sphere/screens/attendance/widgets/attendance_permission_request.dart';

class AttendanceScannerWidget extends StatelessWidget {
  final bool isScanning;
  final bool hasCameraPermission;
  final CameraController? cameraController;
  final Animation<double> laserAnimation;
  final String scanStatusMessage;
  final double scanProgress;
  final VoidCallback onCancelScan;
  final VoidCallback onRequestPermission;

  const AttendanceScannerWidget({
    super.key,
    required this.isScanning,
    required this.hasCameraPermission,
    this.cameraController,
    required this.laserAnimation,
    required this.scanStatusMessage,
    required this.scanProgress,
    required this.onCancelScan,
    required this.onRequestPermission,
  });

  @override
  Widget build(BuildContext context) {
    if (!isScanning) return const SizedBox.shrink();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 350,
        color: Colors.black,
        child: hasCameraPermission
            ? AttendanceActiveScanner(
                cameraController: cameraController,
                laserAnimation: laserAnimation,
                scanStatusMessage: scanStatusMessage,
                scanProgress: scanProgress,
                onCancelScan: onCancelScan,
              )
            : AttendancePermissionRequest(
                onRequestPermission: onRequestPermission,
              ),
      ),
    );
  }
}