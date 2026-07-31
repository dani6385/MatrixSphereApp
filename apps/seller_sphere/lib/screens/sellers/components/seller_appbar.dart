import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
//import 'package:shared_ui/shared_ui.dart';

class SellerAppBar extends StatefulWidget implements PreferredSizeWidget {
  const SellerAppBar({super.key});

  @override
  State<SellerAppBar> createState() => _SellerAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SellerAppBarState extends State<SellerAppBar> {
  // Nilai awal yang terpilih di dropdown

  // Daftar opsi menu yang diminta

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Seller'),
    );
  }
}