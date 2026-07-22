import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:seller_sphere/providers/app_viewmodel.dart';
import 'package:seller_sphere/screens/attendance/widgets/action_buttons_card.dart';
import 'package:seller_sphere/screens/attendance/widgets/header_card.dart';
import 'package:seller_sphere/screens/attendance/widgets/history_section.dart';
import 'package:seller_sphere/screens/attendance/widgets/scanner_interface.dart';
import 'package:provider/provider.dart';

class AttendanceBody extends StatelessWidget {
  final bool isScanning;
  final bool hasCameraPermission;
  final CameraController? cameraController;
  final Animation<double> laserAnimation;
  final String scanStatusMessage;
  final double scanProgress;
  final VoidCallback onCancelScan;
  final VoidCallback onRequestPermission;
  final VoidCallback onClockIn;
  final VoidCallback onClockOut;

  const AttendanceBody({
    super.key,
    required this.isScanning,
    required this.hasCameraPermission,
    this.cameraController,
    required this.laserAnimation,
    required this.scanStatusMessage,
    required this.scanProgress,
    required this.onCancelScan,
    required this.onRequestPermission,
    required this.onClockIn,
    required this.onClockOut,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppViewModel>(context);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        HeaderCard(ownerName: viewModel.ownerName),
        const SizedBox(height: 16),
        isScanning
            ? ScannerInterface(
                hasCameraPermission: hasCameraPermission,
                cameraController: cameraController,
                laserAnimation: laserAnimation,
                scanStatusMessage: scanStatusMessage,
                scanProgress: scanProgress,
                onCancelScan: onCancelScan,
                onRequestPermission: onRequestPermission,
              )
            : ActionButtonsCard(onClockIn: onClockIn, onClockOut: onClockOut),
        const SizedBox(height: 16),
        HistorySection(records: viewModel.attendanceList),
      ],
    );
  }
}