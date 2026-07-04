import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/presentation/login_screens/providers/auth_provider.dart'; // Pastikan path ini benar
import 'package:seller_sphere/providers/theme_provider.dart'; // Pastikan path ini benar
import 'package:seller_sphere/presentation/settings_screens/providers/notification_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profil Saya'),
            subtitle: const Text('Lihat dan kelola profil Anda'),
            onTap: () {
              context.push('/profile');
            },
          ),
          SwitchListTile(
            title: const Text('Mode Gelap'),
            subtitle: const Text('Aktifkan untuk tema gelap'),
            value: themeProvider.isDarkMode,
            onChanged: (bool value) {
              // Panggil method di provider untuk mengubah tema
              themeProvider.toggleTheme(value);
            },
          ),
          SwitchListTile(
            title: const Text('Notifikasi'),
            subtitle: const Text('Izinkan aplikasi mengirim notifikasi'),
            value: notificationProvider.areNotificationsEnabled,
            onChanged: (bool value) {
              notificationProvider.toggleNotifications(value);
            },
          ),
          ListTile(
            title: const Text('Tentang Aplikasi'),
            leading: const Icon(Icons.info_outline),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Seller Sphere',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 MatrixSphere',
              );
            },
          ),
          ListTile(
            title: const Text('Keluar'),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Konfirmasi Keluar'),
                  content: const Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
                  actions: [
                    TextButton(
                      child: const Text('Batal'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                    TextButton(
                      child: const Text('Keluar', style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        // Tutup dialog terlebih dahulu
                        Navigator.of(ctx).pop();
                        Provider.of<AuthProvider>(context, listen: false).logout();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}