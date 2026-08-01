// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'components/home_appbar.dart';
import 'components/home_body.dart';
import 'components/home_drawer.dart';
import 'components/home_end_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.darkScaffoldBackgroundColor,
      appBar: const HomeAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: const HomeDrawer(),
      endDrawer: const HomeEndDrawer(),
      body: HomeBody(
        isScanning: false,
        hasCameraPermission: false,
        isCheckingLocation: false,
        laserAnimation: const AlwaysStoppedAnimation(0.0), // Placeholder for Animation<double>
        scanStatusMessage: '',
        scanProgress: 0.0,
        onCancelScan: () {},
        onRequestPermission: () {},
        onClockIn: () {},
        onClockOut: () {},
        onSync: () {},
      ),
    );
  }
}
