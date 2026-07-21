// lib/screens/System/System_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
 
//import '../../../widgets/side_menu.dart';
import 'widgets/system_app_bar.dart';
import 'widgets/System_body.dart';


class SystemScreen extends StatelessWidget {
  const SystemScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kBrandTertiary,
      appBar: const SystemAppBar(),
      drawer: const SideMenu(selectedRoute: MenuRoute.system),
      //endDrawer: const SettingScreen(),
      body: const SystemBody(),
    );
  }
}