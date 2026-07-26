// lib/screens/attendance/attendance_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';


import 'widgets/attendance_app_bar.dart';
import 'widgets/attendance_body.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AttendanceAppBar(),
      drawer: const SideMenu(selectedRoute: MenuRoute.account),
      endDrawer: const SideMenu(selectedRoute: MenuRoute.system), 
      body: const AttendanceBody(),
    );
  }
}