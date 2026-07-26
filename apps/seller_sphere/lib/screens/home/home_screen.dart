// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/navigation/app_navigation.dart';
import 'widgets/menu_model.dart'; // Pastikan class di dalamnya bernama AccountMenuModal atau MenuModel
import 'widgets/home_app_bar.dart';
import 'widgets/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 1. DEKLARASIKAN GLOBALKEY DI SINI
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey, // 2. PASANGKAN KEY KE SINI
      backgroundColor: kBrandTertiary,
      appBar: const HomeAppBar(),
      drawer:
          const MenuModel(), // Sesuaikan nama kelas menu samping Anda (MenuModel atau AccountMenuModal)
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: kBrandSecondary),
              child: Text('Pengaturan',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Buka Pengaturan'),
              onTap: () {
                Navigator.pop(context); // Tutup drawer terlebih dahulu
                AppNavigation.pushTosetting(context); // Panggil metode navigasi
              },
            ),
          ],
        ),
      ),
      body: const HomeBody(),
    );
  }
}
