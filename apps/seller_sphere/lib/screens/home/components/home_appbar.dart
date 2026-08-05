// lib/features/home/presentation/widgets/home_app_bar.dart

import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      // Latar belakang transparan agar gradient dari body terlihat.[cite: 10]
      backgroundColor: Colors.transparent,
      elevation: 0,
      
      // Tombol ikon di sebelah kiri untuk membuka Drawer utama
      leading: IconButton(
        icon: Icon(
          Icons.person_outline, // Ikon garis tiga standar untuk Drawer
          color: colorScheme.onSurface,
        ),
        onPressed: () {
          // Perintah untuk membuka Drawer dari sisi kiri
          Scaffold.of(context).openDrawer();
        },
      ),

      // Judul AppBar.[cite: 10]
      title: Text(
        'Home',
        style: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,

      // Tombol di sebelah kanan (actions) untuk membuka EndDrawer (profil/pengaturan).
      actions: [
        IconButton(
          icon: Icon(
            Icons.settings, // Ikon profil atau akun untuk EndDrawer
            color: colorScheme.onSurface,
          ),
          onPressed: () {
            // Perintah untuk membuka EndDrawer dari sisi kanan
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}