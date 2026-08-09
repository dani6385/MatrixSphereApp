// lib/screens/widgets/management_app_bar.dart

import 'package:flutter/material.dart';

class ManagementAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ManagementAppBar({super.key});

  @override
  State<ManagementAppBar> createState() => _ManagementAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ManagementAppBarState extends State<ManagementAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      
      // Tombol di sebelah kiri untuk membuka Drawer utama
      leading: IconButton(
        icon: const Icon(Icons.dashboard_customize), // Ikon khusus area manajemen
        tooltip: 'Buka Menu Navigasi',
        onPressed: () {
          // Membuka Drawer dari sisi kiri
          Scaffold.of(context).openDrawer();
        },
      ),

      title: const Text('Management'),
      centerTitle: true,

      // Tombol di sebelah kanan untuk membuka EndDrawer (pengaturan manajemen/akun)
      actions: [
        IconButton(
          icon: const Icon(Icons.manage_accounts), // Ikon manajemen akun/pengaturan
          tooltip: 'Buka Pengaturan Manajemen',
          onPressed: () {
            // Membuka EndDrawer dari sisi kanan
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }
}