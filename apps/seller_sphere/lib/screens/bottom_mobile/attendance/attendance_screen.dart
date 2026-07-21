// lib/screens/Attendan/Attendan_screen.dart

import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/bottom_mobile/attendance/widgets/attendance_body.dart';
import 'package:shared_ui/shared_ui.dart';

//import 'widgets/menu_model.dart'; // Pastikan class di dalamnya bernama AccountMenuModal atau MenuModel
//import 'widgets/attendance_app_bar.dart';
//import 'widgets/attendance_body.dart';
import '../../settings/setting_screen.dart';

class AttendanScreen extends StatelessWidget {
  const AttendanScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kBrandTertiary,
      //appBar: const AttendanceAppBar(),
      drawer: const SideMenu(selectedRoute: MenuRoute.sellers),
      endDrawer: const SettingScreen(), 
      body: const AttendanceBody(),
    );
  }
}