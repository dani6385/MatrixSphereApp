import 'package:flutter/material.dart';
import 'package:seller_sphere/navigation/app_extractor.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceDrawer extends StatelessWidget {
  const AttendanceDrawer({super.key});  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: kDarkBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: kAccent,
                  child: Icon(Icons.person, size: 40, color: kLightTextPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Menu Kehadiran',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: kLightTextPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Pilihan navigasi',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: kLightTextSecondary,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: kLightTextPrimary),
            title: const Text('Home', style: TextStyle(color: kLightTextPrimary)),
            onTap: () {
              HomeScreen;
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag, color: kLightTextPrimary),
            title: const Text('Produk', style: TextStyle(color: kLightTextPrimary)),
            onTap: () {
              PublicProductScreen;
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: kLightTextPrimary),
            title: const Text('Pengaturan', style: TextStyle(color: kLightTextPrimary)),
            onTap: () {
              SettingScreen;
            },
          ),
          ListTile(
            leading: const Icon(Icons.person, color: kLightTextPrimary),
            title: const Text('Profil', style: TextStyle(color: kLightTextPrimary)),
            onTap: () {
              //context.go(AppRoutes.profile);
            },
          ),
        ],
      ),
    );
  }
}
