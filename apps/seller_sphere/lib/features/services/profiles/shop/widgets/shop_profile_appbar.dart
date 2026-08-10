import 'package:flutter/material.dart';

class ShopProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShopProfileAppBar({
    super.key,
    this.title = 'Profil Toko',
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}