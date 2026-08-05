// lib/navigation/widgets/app_navigator_drawer.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../app_navigation.dart';

class AppNavigatorDrawer extends StatelessWidget {
  const AppNavigatorDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: kTransparent,
            ),
            child: Text(
              'Menu Utama',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil Saya'),
            onTap: () {
              Navigator.pop(context);
              //AppNavigation.pushToProfile(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Logout (ke Halaman Login)'),
            onTap: () => AppNavigation.goToLogin(context),
          ),
        ],
      ),
    );
  }
}
