
import 'package:flutter/material.dart';


class ManagementAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ManagementAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Management'),
      centerTitle: true,
      // Tombol untuk membuka laci kiri (drawer)
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded),
        tooltip: 'Buka Menu',
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      // Tombol untuk membuka laci kanan (endDrawer)
      actions: [
        IconButton(
          icon: const Icon(Icons.tune_rounded),
          tooltip: 'Buka Filter atau Pengaturan',
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}