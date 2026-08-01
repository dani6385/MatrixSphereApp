import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      // Latar belakang transparan agar gradient dari body terlihat.
      backgroundColor: Colors.transparent,
      elevation: 0,
      // Judul AppBar.
      title: Text(
        'Home',
        style: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      // Tombol di sebelah kanan (actions).
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}