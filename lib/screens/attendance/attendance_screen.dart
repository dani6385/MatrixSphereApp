// lib/screens/Attendan/Attendan_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

//import 'widgets/menu_model.dart'; // Pastikan class di dalamnya bernama AccountMenuModal atau MenuModel
//import 'widgets/attendan_app_bar.dart';
//import 'widgets/attendan_body.dart';
import '../settings/setting_screen.dart';

class AttendanScreen extends StatelessWidget {
  const AttendanScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kBrandTertiary,
      //appBar: const AttendanAppBar(),
      //drawer: const MenuModel(), // Sesuaikan nama kelas menu samping Anda (MenuModel atau AccountMenuModal)
      endDrawer: const SettingScreen(), 
      //body: const AttendanBody(),
    );
  }
}