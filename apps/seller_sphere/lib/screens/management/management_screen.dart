// lib/screens/Management_screen.dart

import 'package:flutter/material.dart';

import 'components/management_appbar.dart';
import 'components/management_body.dart';
import 'components/management_drawer.dart';
import 'components/Management_end_drawer.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ManagementAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: ManagementDrawer(),
      endDrawer: ManagementEndDrawer(),
      body: ManagementBody(),
    );
  }
}