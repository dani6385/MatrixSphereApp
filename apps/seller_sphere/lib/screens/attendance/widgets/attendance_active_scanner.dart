// lib/screens/attendance/widgets/attendance_active_scanner.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class AttendanceActiveScanner extends StatelessWidget {
  final CameraController? cameraController;
  final Animation<double> laserAnimation;
  final String scanStatusMessage;
  final double scanProgress;
  final VoidCallback onCancelScan;

  const AttendanceActiveScanner({
    super.key,
    required this.cameraController,
    required this.laserAnimation,
    required this.scanStatusMessage,
    required this.scanProgress,
    required this.onCancelScan,
  });

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(cameraController!),
        ),
        AnimatedBuilder(
          animation: laserAnimation,
          builder: (context, child) {
            return Positioned(
              top: 350 * laserAnimation.value,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary,
                      blurRadius: 5,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black.withValues(alpha: 0.7),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(scanStatusMessage, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: scanProgress),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: onCancelScan,
                  child: const Text('Batalkan', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}