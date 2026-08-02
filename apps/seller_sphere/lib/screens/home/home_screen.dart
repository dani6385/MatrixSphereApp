
import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/home/components/home_appbar.dart';
import 'package:seller_sphere/screens/home/components/home_drawer.dart';
import 'package:seller_sphere/screens/home/components/home_end_drawer.dart';

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
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
