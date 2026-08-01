// lib/screens/Seller_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'components/seller_appbar.dart';
import 'components/seller_body.dart';
import 'components/Seller_drawer.dart';
import 'components/Seller_end_drawer.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANG GLOBALKEY KE SCAFFOLD
      // Menerapkan warna latar belakang dari AppStyles (Tema Gelap/Terang)
      backgroundColor: AppStyles.darkScaffoldBackgroundColor, 
      appBar: const SellerAppBar(),
      drawerEnableOpenDragGesture: false,
      endDrawerEnableOpenDragGesture: false,
      drawer: const SellerDrawer(),
      endDrawer: const SellerEndDrawer(),
      body: const SellerBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman produk untuk menambah produk baru
          context.go(AppRoutes.products);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}