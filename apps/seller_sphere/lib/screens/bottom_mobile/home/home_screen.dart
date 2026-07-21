// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';


import 'widgets/home_app_bar.dart';
import 'widgets/home_body.dart';
import '../../settings/setting_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kBrandTertiary,
      appBar: const HomeAppBar(),
      drawer: const SideMenu(selectedRoute: MenuRoute.account),
      endDrawer: const SettingScreen(), 
      body: const HomeBody(),
    );
  }
}