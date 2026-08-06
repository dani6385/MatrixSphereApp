import 'package:flutter/material.dart';
import 'package:logger/logger.dart';





import 'package:seller_sphere/navigations/app_extractor.dart';

final Logger logger = Logger();

/// Halaman untuk menampilkan berbagai opsi pengaturan aplikasi.
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // Variabel state untuk mengontrol switch

  ThemeMode? _currentThemeMode = ThemeMode.system; // Initialize with a default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // --- Bagian Akun ---
          _buildSectionHeader(context, 'Akun'),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profil'),
            subtitle: const Text('Ubah informasi profil Anda'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              logger.i('Menu profile diklik!');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigasi ke halaman Profile.')),
              );
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Keamanan'),
            subtitle: const Text('Ubah kata sandi dan pengaturan keamanan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              logger.i('Menu profile diklik!');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigasi ke halaman Profile.')),
              );
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const SecurityScreen()),
              );
            },
          ),
          const Divider(),

          // --- Bagian Aplikasi ---
          _buildSectionHeader(context, 'Aplikasi'),
          ListTile(
            leading: const Icon(
                Icons.brightness_6_outlined), // Ikon untuk pengaturan tema
            title: const Text('Tema Aplikasi'),
            trailing: DropdownButton<ThemeMode>(
              value: _currentThemeMode, // Nilai yang sedang aktif saat ini
              onChanged: (ThemeMode? newMode) {
                if (newMode != null) {
                  setState(() {
                    _currentThemeMode = newMode;
                  });
                }
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('Notifikasi'),
            subtitle: const Text('Aktifkan notifikasi aplikasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              logger.i('Menu Bahasa diklik!');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigasi ke halaman Bahasa.')),
              );
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const NotificationSettingScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Bahasa'),
            subtitle: const Text('Pilih bahasa aplikasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              logger.i('Menu Bahasa diklik!');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigasi ke halaman Bahasa.')),
              );
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const LanguageScreen()),
              );
            },
          ),
          const Divider(),

          // --- Bagian Tentang ---
          _buildSectionHeader(context, 'Tentang'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Pusat Bantuan'),
            onTap: () {
              logger.i('Menu Pusat Bantuan diklik!');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigasi ke halaman Pusat Bantuan.')),
              );
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang Aplikasi'),
            onTap: () {
              logger.i('Menu Tentang Aplikasi diklik!');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Navigasi ke halaman Tentang Aplikasi.')),
              );
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const InfoScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Widget helper untuk membuat header setiap bagian.
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
