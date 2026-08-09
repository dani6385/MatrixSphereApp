// lib/screens/sellers/components/seller_appbar.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class SellerAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SellerAppBar({super.key});

  @override
  State<SellerAppBar> createState() => _SellerAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SellerAppBarState extends State<SellerAppBar> {
  @override
  Widget build(BuildContext context) {
    // Menerapkan gaya AppBar terpusat dari AppStyles (misalnya menggunakan tema gelap)
    final appBarTheme = AppStyles.darkAppBarTheme;

    return AppBar(
      backgroundColor: appBarTheme.backgroundColor,
      elevation: appBarTheme.elevation,
      iconTheme: appBarTheme.iconTheme,
      titleTextStyle: appBarTheme.titleTextStyle,
      
      // Tombol di sebelah kiri untuk membuka Drawer utama
      leading: IconButton(
        icon: const Icon(Icons.storefront), // Ikon toko khusus halaman seller
        tooltip: 'Buka Menu Utama',
        onPressed: () {
          // Membuka Drawer dari sisi kiri
          Scaffold.of(context).openDrawer();
        },
      ),

      title: const Text('Seller'),
      centerTitle: true,

      // Tombol di sebelah kanan untuk membuka EndDrawer (pengaturan/pembayaran seller)
      actions: [
        IconButton(
          icon: const Icon(Icons.payments_outlined), // Ikon pembayaran/pengaturan toko
          tooltip: 'Buka Pengaturan Seller',
          onPressed: () {
            // Membuka EndDrawer dari sisi kanan
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }
}