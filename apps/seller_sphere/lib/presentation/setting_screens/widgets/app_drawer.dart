import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


/// Widget untuk menampilkan drawer navigasi utama aplikasi.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendapatkan rute saat ini untuk menyorot item yang aktif
    final currentRoute = GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.teal, // Sesuaikan dengan tema aplikasi Anda
            ),
            child: Text(
              'Seller Sphere',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            selected: currentRoute == '/',
            onTap: () {
              // Tutup drawer dan navigasi ke home
              context.pop();
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Pengaturan'),
            selected: currentRoute == '/settings',
            onTap: () {
              // Tutup drawer dan navigasi ke settings
              context.pop();
              context.push('/settings');
            },
          ),
        ],
      ),
    );
  }
}