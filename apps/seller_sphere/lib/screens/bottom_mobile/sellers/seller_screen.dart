// lib/screens/Seller/Seller_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
 
//import '../../../widgets/side_menu.dart';
import 'widgets/seller_app_bar.dart';
import 'widgets/seller_body.dart';


class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kBrandTertiary,
      appBar: const SellerAppBar(),
      drawer: const SideMenu(selectedRoute: MenuRoute.sellers),
      //endDrawer: const SettingScreen(), 
      body: const SellerBody(),
    );
  }
}