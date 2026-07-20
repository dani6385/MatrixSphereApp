import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';

class SettingBody extends StatelessWidget {
  const SettingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          const SizedBox(height: AppSpacing.md),
          _buildSettingSectionTitle(context, 'UMUM'),
          _buildSettingItem(
            context,
            icon: Icons.person_outline,
            title: 'Akun & Profil',
            subtitle: 'Ubah sandi, email, keamanan biometrik',
            onTap: () {},
          ),
          _buildSettingItem(
            context,
            icon: Icons.notifications_none_outlined,
            title: 'Notifikasi',
            subtitle: 'Atur nada dering & tanda pesan masuk',
            onTap: () {},
          ),
          _buildSettingItem(
            context,
            icon: Icons.language_outlined,
            title: 'Bahasa Aplikasi',
            subtitle: 'Bahasa Indonesia (Default)',
            onTap: () {},
          ),
          const Divider(color: Colors.white12, height: 32),
          _buildSettingSectionTitle(context, 'SISTEM'),
          _buildSettingItem(
            context,
            icon: Icons.brightness_6_outlined,
            title: 'Tema Aplikasi',
            subtitle: 'Ubah ke Mode Terang/Gelap',
            onTap: () {
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
            },
          ),
          _buildSettingItem(
            context,
            icon: Icons.security_outlined,
            title: 'Keamanan Sidik Jari',
            subtitle: 'Kunci aplikasi dengan biometrik',
            onTap: () {},
          ),
          const Divider(color: Colors.white12, height: 32),
          _buildSettingSectionTitle(context, 'INFORMASI'),
          _buildSettingItem(
            context,
            icon: Icons.info_outline,
            title: 'Tentang Aplikasi',
            subtitle: 'Matrix Sphere v1.4.2',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: kDarkTextSecondary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(icon, color: kDarkTextSecondary),
      title: Text(title, style: textTheme.bodyLarge?.copyWith(color: kDarkTextPrimary)),
      subtitle: Text(subtitle, style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
      trailing: const Icon(Icons.chevron_right, color: kDarkTextSecondary, size: 20),
      onTap: onTap,
    );
  }
}
