// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'components/home_appbar.dart';
import 'components/home_body.dart';
import 'widgets/home_drawer.dart';
import 'widgets/home_end_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: HomeDrawer(),
      endDrawer: HomeEndDrawer(),
      body: HomeBody(),
    );
  }
}