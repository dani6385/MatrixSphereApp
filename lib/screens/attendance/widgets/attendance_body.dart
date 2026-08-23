// lib/screens/attendance/widgets/attendance_body.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shared_providers/shared_providers.dart';
import 'package:shared_screens/shared_screens.dart';

class AttendanceBody extends StatelessWidget {
  final bool isCameraInitialized;
  final CameraController? cameraController;
  final bool isLoadingLocation;
  final bool isInRange;
  final double distanceToOffice;
  final bool isProcessing;
  final VoidCallback? onSubmit;

  const AttendanceBody({
    Key? key,
    required this.isCameraInitialized,
    required this.cameraController,
    required this.isLoadingLocation,
    required this.isInRange,
    required this.distanceToOffice,
    required this.isProcessing,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isCameraInitialized || cameraController == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        // Preview Kamera
        Positioned.fill(
          child: CameraPreview(cameraController!),
        ),
        
        // Bingkai Lingkaran Wajah
        const FaceOverlay(),
        
        // Panel Informasi & Tombol Absen
        ControlPanel(
          isLoadingLocation: isLoadingLocation,
          isInRange: isInRange,
          distanceToOffice: distanceToOffice,
          isProcessing: isProcessing,
          onSubmit: onSubmit,
        ),
      ],
    );
  }
}