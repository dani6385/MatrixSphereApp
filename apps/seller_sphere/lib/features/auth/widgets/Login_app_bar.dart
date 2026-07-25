
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LoginAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Login'),
      centerTitle: true,
      backgroundColor: kDarkBorder,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}