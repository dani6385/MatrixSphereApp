
import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/login/login_screen.dart'; // Import LoginScreen
import 'package:shared_ui/shared_ui.dart';

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LoginAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Login'),
      centerTitle: true,
      backgroundColor: kDarkBorder,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: kBrandBlack),
        onPressed: () {
          LoginScreen.scaffoldKey.currentState?.openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: kBrandBlack),
          onPressed: () {
            LoginScreen.scaffoldKey.currentState?.openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}