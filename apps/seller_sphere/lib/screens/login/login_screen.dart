// lib/screens/Login/Login_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'widgets/Login_app_bar.dart';
import 'widgets/Login_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kBrandTertiary,
      appBar: const LoginAppBar(),
      //drawer: const SideMenu(selectedRoute: MenuRoute.account),
      //endDrawer: const SettingScreen(),
      body: const LoginBody(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: kDarkOutline.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SafeArea(
          child: Text(
            '© 2024 MatrixSphere. All rights reserved.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
