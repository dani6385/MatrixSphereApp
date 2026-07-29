// lib/screens/Inventory/Inventory_screen.dart

import 'package:flutter/material.dart';

import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

import 'widgets/inventory_app_bar.dart';
import 'widgets/inventory_body.dart';
import 'package:seller_sphere/features/settings/setting_screen.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const InventoryAppBar(),
      drawer: const SideMenu(selectedRoute: MenuRoute.account),
      endDrawer: const SettingScreen(),
      body: InventoryBody(
        onSaveProduct: (Product productData) async {},
        onDeleteProduct: (String productName) async {},
        productsRef: null as dynamic,
      ),
    );
  }
}
