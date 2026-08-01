// lib/screens/Home/widgets/Home_body.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:seller_sphere/screens/home/widgets/home_quick_actions_grid.dart';
import 'package:seller_sphere/screens/home/widgets/home_recent_activity_list.dart';
import 'package:seller_sphere/screens/home/widgets/home_section_header.dart';
import 'package:seller_sphere/screens/home/widgets/home_summary_section.dart';
import 'package:seller_sphere/screens/home/widgets/home_welcome_header.dart';

class HomeBody extends StatelessWidget {
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
  //final List<HomeRecord> HomeHistory;
  final VoidCallback onSync;

  const HomeBody({
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
    //required this.HomeHistory,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          //const HomeHeaderCard(),
          HomeSummarySection(),
          SizedBox(height: 24),
          HomeQuickActionsGrid(),
          SizedBox(height: 24),
          HomeSectionHeader(title: 'Aktivitas Terbaru'),
          SizedBox(height: 16),
          HomeWelcomeHeader(sellerName: '',),
          SizedBox(height: 24),
          HomeRecentActivityList(),
          /*isScanning
              ? HomeScannerWidget(
                  isScanning: isScanning,
                  hasCameraPermission: hasCameraPermission,
                  cameraController: cameraController,
                  laserAnimation: laserAnimation,
                  scanStatusMessage: scanStatusMessage,
                  scanProgress: scanProgress,
                  onCancelScan: onCancelScan,
                  onRequestPermission: onRequestPermission,
                )
              : HomeActionButtons(
                  isCheckingLocation: isCheckingLocation,
                  onClockIn: onClockIn,
                  onClockOut: onClockOut,
                ),*/
          SizedBox(height: 24),
          HomeSectionHeader(title: 'Riwayat Kehadiran'),
          //HomeHistoryHeader(onSync: onSync),
          SizedBox(height: 8),
          //HomeHistorySection(HomeHistory: HomeHistory),
        ],
      ),
    );
  }
}