// lib/screens/Setting/Setting_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'contents/setting_content.dart'; // Pastikan class di dalamnya bernama AccountMenuModal atau MenuModel
//import 'widgets/Setting_app_bar.dart';
//import 'widgets/Setting_body.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kLightSurface,
      //appBar: const SettingAppBar(),
      //drawer: const MenuModel(), // Sesuaikan nama kelas menu samping Anda (MenuModel atau AccountMenuModal)
      body: const SettingsContent(),
    );
  }
}