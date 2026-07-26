import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere/navigation/app_routes.dart';

class ShopDrawer extends StatelessWidget {
  const ShopDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Shop Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              context.goNamed(AppRoutes.home);
            },
          ),
          /*ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Products'),
            onTap: () {
              context.goNamed(AppRoutes.products);
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Categories'),
            onTap: () {
              context.goNamed(AppRoutes.categories);
            },
          ),*/
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account'),
            onTap: () {
              context.goNamed(AppRoutes.account);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              context.goNamed(AppRoutes.settings);
            },
          ),
        ],
      ),
    );
  }
}