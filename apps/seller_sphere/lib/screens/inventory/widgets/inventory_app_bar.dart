import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

/// AppBar kustom untuk InventoryScreen yang menyertakan TabBar dan actions.
class InventoryAppBar extends StatelessWidget implements PreferredSizeWidget {
 

  const InventoryAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Manajemen Seller',
        style: TextStyle(
          color: kDarkTextPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: kDarkAppBar,
      elevation: 1,
    );
  }
  @override
  Size get preferredSize =>
      // Tinggi AppBar standar ditambah tinggi TabBar
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}