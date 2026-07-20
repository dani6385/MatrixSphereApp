// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'widgets/menu_model.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kLightSurface,
      appBar: HomeAppBar(),
      drawer: MenuModel(),
      
      // Menggunakan HomeBody murni untuk menghindari crash tata letak
      body: HomeBody(), 
    );
  }
}