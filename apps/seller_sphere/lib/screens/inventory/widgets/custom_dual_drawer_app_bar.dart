// lib/src/widgets/custom_dual_drawer_app_bar.dart

import 'package:flutter/material.dart';

/// Sebuah custom AppBar yang memiliki tombol laci (drawer) di sisi kiri dan kanan.
/// Cocok digunakan untuk halaman utama yang membutuhkan panel navigasi dan kontrol tambahan.
class CustomDualDrawerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final List<Widget>? actions;

  const CustomDualDrawerAppBar({
    super.key,
    required this.titleText,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titleText,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      elevation: 2,
      // 1. Tombol Ikon di Sisi Kiri untuk Membuka Laci Kiri (Drawer)
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded),
        tooltip: 'Buka Menu Utama',
        onPressed: () {
          // Perintah untuk membuka laci dari sisi kiri
          Scaffold.of(context).openDrawer();
        },
      ),
      // 2. Tombol Ikon di Sisi Kanan untuk Membuka Laci Kanan (EndDrawer)
      actions: [
        ...?actions, // Menyisipkan aksi tambahan jika ada
        IconButton(
          icon: const Icon(Icons.tune_rounded), // Contoh ikon filter/pengaturan kanan
          tooltip: 'Buka Panel Samping',
          onPressed: () {
            // Perintah untuk membuka laci dari sisi kanan
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}