import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'home_screen.dart';
import 'seller_screen.dart';
import 'approval_screen.dart';
import 'system_screen.dart';
import 'settings_screen.dart';


class MainAppScaffold extends StatelessWidget {
  const MainAppScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      screens: [
        HomeScreen(),
        SellerScreen(),
        ApprovalScreen(),
        SystemScreen(),
        SettingsScreen(),
      ],
    );
  }
}
