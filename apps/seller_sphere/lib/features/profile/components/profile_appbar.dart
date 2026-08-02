
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        // Inilah ikon yang Anda ingin ganti.
        // Saya akan menggantinya dari Icons.menu menjadi Icons.dashboard_customize_outlined
        icon: const Icon(Icons.dashboard_customize_outlined),
        tooltip: 'Open Menu',
        onPressed: () {
          // Logika untuk membuka drawer utama (kiri)
          Scaffold.of(context).openDrawer();
        },
      ),
      title: const Text('Profile'),
      // You can add more AppBar properties here if needed
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.edit),
      //     onPressed: () {
      //       // Handle edit action
      //     },
      //   ),
      // ],
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: 'Pengaturan',
          onPressed: () {
            // Logika untuk membuka endDrawer (kanan)
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
