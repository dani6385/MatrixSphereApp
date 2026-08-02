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
    return Scaffold( // Scaffold itself will have a transparent background by default
      appBar: const HomeAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: const HomeDrawer(),
      endDrawer: const HomeEndDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppStyles.darkScaffoldBackgroundColor(context),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const HomeBody(),
      ),
    );
  }
}
