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
    return const Scaffold(
      backgroundColor: AppStyles.darkScaffoldBackgroundColor,
      appBar: HomeAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: HomeDrawer(),
      endDrawer: HomeEndDrawer(),
      body: HomeBody(),
    );
  }
}