import 'package:flutter/material.dart';

/// Halaman untuk menampilkan pengaturan keamanan akun.
class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _isTwoFactorAuthEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keamanan'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Manajemen Kata Sandi'),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Ubah Kata Sandi'),
            subtitle: const Text('Ubah kata sandi Anda secara berkala'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigasi ke halaman ubah kata sandi
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Navigasi ke halaman ubah kata sandi.')),
              );
            },
          ),
          const Divider(),
          _buildSectionHeader(context, 'Autentikasi'),
          SwitchListTile(
            secondary: const Icon(Icons.phonelink_lock),
            title: const Text('Autentikasi Dua Faktor'),
            subtitle: const Text('Tingkatkan keamanan akun Anda'),
            value: _isTwoFactorAuthEnabled,
            onChanged: (bool value) {
              setState(() {
                _isTwoFactorAuthEnabled = value;
                // Implementasikan logika untuk mengaktifkan/menonaktifkan 2FA
              });
            },
          ),
          const Divider(),
          _buildSectionHeader(context, 'Aktivitas Akun'),
          ListTile(
            leading: const Icon(Icons.devices),
            title: const Text('Aktivitas Login'),
            subtitle: const Text('Lihat perangkat yang masuk ke akun Anda'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigasi ke halaman aktivitas login
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