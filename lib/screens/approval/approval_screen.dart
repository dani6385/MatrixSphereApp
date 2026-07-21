// lib/screens/Approval/Approval_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

//import 'widgets/menu_model.dart'; // Pastikan class di dalamnya bernama AccountMenuModal atau MenuModel
//import 'widgets/approval_app_bar.dart';
//import 'widgets/approval_body.dart';
import '../settings/setting_screen.dart';

class ApprovalScreen extends StatelessWidget {
  const ApprovalScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kBrandTertiary,
      //appBar: const ApprovalAppBar(),
      //drawer: const MenuModel(), // Sesuaikan nama kelas menu samping Anda (MenuModel atau AccountMenuModal)
      endDrawer: const SettingScreen(), 
      //body: const ApprovalBody(),
    );
  }
}