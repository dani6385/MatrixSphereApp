import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/presentation/login_screens/providers/auth_provider.dart';
import 'package:seller_sphere/providers/theme_provider.dart'; // Impor provider Riverpod
import 'package:seller_sphere/presentation/settings_screens/providers/notification_provider.dart'; // Impor provider Riverpod

// Pastikan ini adalah ConsumerWidget
class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Gunakan ref.watch untuk mendapatkan state dari provider Riverpod
    final isDarkMode = ref.watch(themeProvider);
    final areNotificationsEnabled = ref.watch(notificationProvider);

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
            value: isDarkMode,
            onChanged: (bool value) {
              // Gunakan ref.read(...).notifier untuk memanggil metode pada notifier
              ref.read(themeProvider.notifier).toggleTheme(value);
            },
          ),
          SwitchListTile(
            title: const Text('Notifikasi'),
            subtitle: const Text('Izinkan aplikasi mengirim notifikasi'),
            value: areNotificationsEnabled,
            onChanged: (bool value) {
              // Gunakan ref.read(...).notifier untuk memanggil metode pada notifier
              ref.read(notificationProvider.notifier).toggleNotifications(value);
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
                        Navigator.of(ctx).pop();
                        // Panggilan logout ini sudah benar
                        ref.read(authProvider.notifier).logout();
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
