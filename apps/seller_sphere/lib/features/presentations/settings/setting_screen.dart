import 'package:flutter/material.dart';

/// Halaman untuk menampilkan berbagai opsi pengaturan aplikasi.
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // Variabel state untuk mengontrol switch
  bool _isDarkMode = false;
  bool _areNotificationsEnabled = true;

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
              // TODO: Navigasi ke halaman profil
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Keamanan'),
            subtitle: const Text('Ubah kata sandi dan pengaturan keamanan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigasi ke halaman keamanan
            },
          ),
          const Divider(),

          // --- Bagian Aplikasi ---
          _buildSectionHeader(context, 'Aplikasi'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Mode Gelap'),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
                // TODO: Implementasikan logika untuk mengubah tema aplikasi
              });
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifikasi'),
            subtitle: const Text('Aktifkan notifikasi aplikasi'),
            value: _areNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _areNotificationsEnabled = value;
                // TODO: Implementasikan logika untuk mengontrol notifikasi
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Bahasa'),
            subtitle: const Text('Pilih bahasa aplikasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigasi ke halaman pilihan bahasa
            },
          ),
          const Divider(),

          // --- Bagian Tentang ---
          _buildSectionHeader(context, 'Tentang'),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Pusat Bantuan'),
            onTap: () {
              // TODO: Navigasi ke halaman bantuan
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang Aplikasi'),
            onTap: () {
              // TODO: Tampilkan dialog tentang aplikasi
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