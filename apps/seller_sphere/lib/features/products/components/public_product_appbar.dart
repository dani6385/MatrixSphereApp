// lib/screens/products/widgets/public_product_appbar.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class PublicProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PublicProductAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Semua Produk'),
      backgroundColor: kDarkSecondary,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}