// lib/screens/Profile/Profile_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';


import 'widgets/Profile_app_bar.dart';
import 'widgets/Profile_body.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kBrandTertiary,
      appBar: const ProfileAppBar(),
      //drawer: const SideMenu(selectedRoute: MenuRoute.account),
      //endDrawer: const SettingScreen(),
      body: const ProfileBody(),
    );
  }
}