// lib/screens/Account/Account_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
 
import 'widgets/account_app_bar.dart';
import 'widgets/account_body.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kBrandTertiary,
      appBar: const AccountAppBar(),
      drawer: const SideMenu(selectedRoute: MenuRoute.account),
      //endDrawer: const SettingScreen(), 
      body: const AccountBody(),
    );
  }
}