
import 'package:flutter/material.dart';

class SellerAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SellerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Sellers'),
      // Add any specific actions or leading widgets for SellerAppBar
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
