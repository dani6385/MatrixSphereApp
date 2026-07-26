// lib/screens/Inventory/Inventory_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';


import 'widgets/inventory_app_bar.dart';
import 'widgets/inventory_body.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key, required Null Function(Map) onNavigateToLabelPrinter});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: InventoryAppBar(onSearchChanged: (String value) {  },),
      drawer: const SideMenu(selectedRoute: MenuRoute.account),
      endDrawer: const SideMenu(selectedRoute: MenuRoute.system), 
      body: const InventoryBody(),
    );
  }
}