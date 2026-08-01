import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
// lib/screens/sellers/components/seller_appbar.dart


class SellerAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SellerAppBar({super.key});

  @override
  State<SellerAppBar> createState() => _SellerAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SellerAppBarState extends State<SellerAppBar> {
  @override
  Widget build(BuildContext context) {
    // Menerapkan gaya AppBar terpusat dari AppStyles (misalnya menggunakan tema gelap)
    final appBarTheme = AppStyles.darkAppBarTheme;

    return AppBar(
      backgroundColor: appBarTheme.backgroundColor,
      elevation: appBarTheme.elevation,
      iconTheme: appBarTheme.iconTheme,
      titleTextStyle: appBarTheme.titleTextStyle,
      title: const Text('Seller'),
      centerTitle: true,
    );
  }
}