// lib/screens/Report_screen.dart

import 'package:flutter/material.dart';
import 'components/report_appbar.dart';
import 'components/report_body.dart';
import 'components/report_drawer.dart';
import 'components/report_end_drawer.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Scaffold itself will have a transparent background by default
      appBar: ReportAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: ReportDrawer(),
      endDrawer: ReportEndDrawer(),
      body: ReportBody(),
    );
  }
}
