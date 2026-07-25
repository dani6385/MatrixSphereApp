// lib/screens/Status/Status_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
 
//import '../../../widgets/side_menu.dart';
import 'widgets/status_app_bar.dart';
import 'widgets/status_body.dart';


class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kBrandTertiary,
      appBar: const StatusAppBar(),
      drawer: const SideMenu(selectedRoute: MenuRoute.sellers),
      //endDrawer: const SettingScreen(),
      body: const StatusBody(),
    );
  }
}