// lib/screens/attendance/attendance_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_navigations/shared_navigations.dart';
import 'package:shared_utils/shared_utils.dart';

// Import komponen lokal
import 'package:shared_logics/shared_logics.dart';
import 'widgets/attendance_app_bar.dart';
import 'widgets/attendance_body.dart';
import 'widgets/attendance_drawer_items.dart';
import 'widgets/attendance_end_drawer_items.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final AttendanceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AttendanceController();
    _controller.initialize(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSuccess() {
    AttendanceDialogs.showSuccess(
      context: context,
      onConfirm: () {
        Navigator.of(context).pop(); // Tutup dialog sukses
        Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder digunakan untuk membangun kembali UI saat _controller memanggil notifyListeners()
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          key: _scaffoldKey,
          drawerEnableOpenDragGesture: false,
          endDrawerEnableOpenDragGesture: false,

          // 1. APP BAR
          appBar: AttendanceAppBar(
            onRefreshLocation: () => _controller.checkLocationAndPermission(context),
            onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
            onOpenEndDrawer: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),

          // 2. DRAWER KIRI
          drawer: SharedProjectDrawer(
            menuBuilder: (context, currentRoute) {
              return getDrawerSideMenuItems(context, currentRoute);
            },
          ),

          // 3. END DRAWER KANAN
          endDrawer: SharedProjectDrawer(
            menuBuilder: (context, currentRoute) {
              return getEndDrawerSideMenuItems(
                context,
                currentRoute,
                officeLocation: _controller.officeLocation,
                currentPosition: _controller.currentPosition,
              );
            },
          ),

          // 4. BODY UTAMA
          body: AttendanceBody(
            isCameraInitialized: _controller.isCameraInitialized,
            cameraController: _controller.cameraController,
            isLoadingLocation: _controller.isLoadingLocation,
            isInRange: _controller.isInRange,
            distanceToOffice: _controller.distanceToOffice,
            isProcessing: _controller.isProcessing,
            onSubmit: (_controller.isInRange && !_controller.isLoadingLocation)
                ? () => _controller.captureAndVerify(context, _handleSuccess)
                : null,
          ),
        );
      },
    );
  }
}
