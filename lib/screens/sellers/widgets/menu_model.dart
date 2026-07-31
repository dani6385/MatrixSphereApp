import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere/routes/app_routes.dart';

/// A Model that displays the menu.
class MenuModel extends StatelessWidget {
  /// Creates an [MenuModel] widget.
  const MenuModel({super.key});  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text(
              'John Doe',
              style: TextStyle(color: kBrandPrimary),
            ),
            accountEmail: const Text(
              'john.doe@example.com',
              style: TextStyle(color: kBrandPrimary),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: kBrandPrimary,
              ),
            ),
            decoration: BoxDecoration(
              color: kBrandSecondary,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              context.go(AppRoutes.home);
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Products'),
            onTap: () {
              // Handle product tap
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Sellers'),
            onTap: () {
              context.go(AppRoutes.sellers);
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle settings tap
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
