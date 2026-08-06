// lib/screens/Home/widgets/Home_body.dart


import 'package:flutter/material.dart';

import 'package:seller_sphere/screens/home/widgets/home_quick_actions_grid.dart';
import 'package:seller_sphere/screens/home/widgets/home_recent_activity_list.dart';
import 'package:seller_sphere/screens/home/widgets/home_section_header.dart';
import 'package:seller_sphere/screens/home/widgets/home_summary_section.dart';
import 'package:seller_sphere/screens/home/widgets/home_welcome_header.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 40.0),
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          //const HomeHeaderCard(),
          HomeWelcomeHeader(sellerName: '',),
          SizedBox(height: 24),
          HomeSummarySection(),
          SizedBox(height: 24),
          HomeSectionHeader(title: 'Aktivitas Terbaru'),
          SizedBox(height: 16),
          HomeQuickActionsGrid(),
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
          // HomeHistoryHeader(onSync: onSync), // Anda bisa aktifkan ini jika sudah siap
          SizedBox(height: 8),
          // HomeHistorySection(HomeHistory: HomeHistory), // Aktifkan ini untuk menampilkan daftar riwayat
        ],
      );
  }
}