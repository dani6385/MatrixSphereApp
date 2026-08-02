// lib/screens/widgets/management_app_bar.dart

import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
//import 'package:shared_ui/shared_ui.dart';

class ManagementAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ManagementAppBar({super.key});

  @override
  State<ManagementAppBar> createState() => _ManagementAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ManagementAppBarState extends State<ManagementAppBar> {
  // Nilai awal yang terpilih di dropdown

  // Daftar opsi menu yang diminta

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: const Text('Management'),
    );
  }
}