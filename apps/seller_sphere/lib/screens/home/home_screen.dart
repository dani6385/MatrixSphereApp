
import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/home/components/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
