// lib/screens/Seller/Seller_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import 'widgets/menu_model.dart'; // Pastikan class di dalamnya bernama AccountMenuModal atau MenuModel
import 'widgets/seller_app_bar.dart';
import 'widgets/seller_body.dart';
import '../setting/setting_screen.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kElectricBlue,
      appBar: const SellerAppBar(),
      drawer: const MenuModel(), // Sesuaikan nama kelas menu samping Anda (MenuModel atau AccountMenuModal)
      endDrawer: const SettingScreen(), 
      body: const SellerBody(),
    );
  }
}