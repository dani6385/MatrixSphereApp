import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
//import 'package:shared_ui/shared_ui.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  // Nilai awal yang terpilih di dropdown

  // Daftar opsi menu yang diminta

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: const Text('Home'),
    );
  }
}