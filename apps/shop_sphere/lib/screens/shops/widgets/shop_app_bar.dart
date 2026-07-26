// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere/navigation/app_routes.dart';
import 'package:shop_sphere/screens/shops/shop_screen.dart';

class ShopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Shop'),
      leading: IconButton(
        icon: const Icon(Icons.account_circle),
        onPressed: () {
          ShopScreen.scaffoldKey.currentState?.openDrawer();
        },
      ),
      actions: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                context.goNamed(AppRoutes.account);
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Handle notification icon press
          },
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            ShopScreen.scaffoldKey.currentState?.openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}