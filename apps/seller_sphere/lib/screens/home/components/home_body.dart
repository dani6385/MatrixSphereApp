// lib/screens/Home/widgets/Home_body.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:seller_sphere/screens/home/widgets/home_quick_actions_grid.dart';
import 'package:seller_sphere/screens/home/widgets/home_recent_activity_list.dart';
import 'package:seller_sphere/screens/home/widgets/home_section_header.dart';
import 'package:seller_sphere/screens/home/widgets/home_screen_widget.dart';
import 'package:seller_sphere/screens/home/widgets/home_summary_section.dart';
import 'package:seller_sphere/screens/home/widgets/home_welcome_header.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({
    super.key,
  });

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> with SingleTickerProviderStateMixin {
  // State untuk scanner dan kamera
  bool isScanning = false; // Ganti menjadi true untuk menampilkan scanner
  bool hasCameraPermission = false; // Akan diupdate setelah memeriksa izin
  CameraController? cameraController;
  late AnimationController _animationController;
  late Animation<double> laserAnimation;
  String scanStatusMessage = 'Arahkan kamera ke kode QR';
  double scanProgress = 0.0;

  // State untuk tombol aksi
  bool isCheckingLocation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    laserAnimation =
        Tween<double>(begin: -1.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    cameraController?.dispose();
    super.dispose();
  }

  // Placeholder untuk fungsi-fungsi yang dibutuhkan
  void onCancelScan() => setState(() => isScanning = false);
  void onRequestPermission() {}
  void onClockIn() {}
  void onClockOut() {}

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 40.0),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          //const HomeHeaderCard(),
          const HomeWelcomeHeader(sellerName: '',),
          const SizedBox(height: 24),
          const HomeSummarySection(),
          const SizedBox(height: 24),
          const HomeSectionHeader(title: 'Aktivitas Terbaru'),
          const SizedBox(height: 16),
          HomeQuickActionsGrid(),
          const SizedBox(height: 24),
          const HomeRecentActivityList(),
          const SizedBox(height: 24),
          isScanning
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
                ),
          const SizedBox(height: 24),
          const HomeSectionHeader(title: 'Riwayat Kehadiran'),
          // HomeHistoryHeader(onSync: onSync), // Anda bisa aktifkan ini jika sudah siap
          const SizedBox(height: 8),
          // HomeHistorySection(HomeHistory: HomeHistory), // Aktifkan ini untuk menampilkan daftar riwayat
        ],
      );
  }
}