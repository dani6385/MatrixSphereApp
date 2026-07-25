// lib/screens/Shop/Shop_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';


import 'widgets/shop_app_bar.dart';
import 'widgets/shop_body.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const ShopAppBar(),
      drawer: const SideMenu(selectedRoute: MenuRoute.account),
      endDrawer: const SideMenu(selectedRoute: MenuRoute.system), 
      body: const ShopBody(),
    );
  }
}