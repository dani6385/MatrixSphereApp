import 'package:flutter/material.dart';

class SellerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SellerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // Menghapus ikon default dan menggantinya dengan IconButton kustom
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
      title: const Text('Seller Dashboard'),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          tooltip: 'Open Filters',
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