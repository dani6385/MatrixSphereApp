
import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/management/components/Management_end_drawer.dart';
import 'package:seller_sphere/screens/management/components/management_appbar.dart';
import 'package:seller_sphere/screens/management/components/management_drawer.dart';

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
      body: Center(
        child: Text('Management Screen Content'),
      ),
    );
  }
}
