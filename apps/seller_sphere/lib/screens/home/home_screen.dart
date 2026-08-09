// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'components/home_appbar.dart';
import 'components/home_body.dart';
import 'components/home_drawer.dart';
import 'components/home_end_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Scaffold itself will have a transparent background by default
      appBar: HomeAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: HomeDrawer(),
      endDrawer: HomeEndDrawer(),
      body: HomeBody(),
    );
  }
}
