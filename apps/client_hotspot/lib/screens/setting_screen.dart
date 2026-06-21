import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode(context);
    final Color iconColor = isDarkMode ? Colors.white : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          _buildSectionHeader(context, 'Tampilan'),
          // ignore: deprecated_member_use
          RadioListTile<ThemeMode>(
            title: const Text('Terang'),
            value: ThemeMode.light,
            // ignore: deprecated_member_use
            groupValue: themeProvider.themeMode,
            // ignore: deprecated_member_use
            onChanged: (newValue) {
              if (newValue != null) {
                Provider.of<ThemeProvider>(context, listen: false).setThemeMode(newValue);
              }
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          // ignore: deprecated_member_use
          RadioListTile<ThemeMode>(
            title: const Text('Gelap'),
            value: ThemeMode.dark,
            // ignore: deprecated_member_use
            groupValue: themeProvider.themeMode,
            // ignore: deprecated_member_use
            onChanged: (newValue) {
              if (newValue != null) {
                Provider.of<ThemeProvider>(context, listen: false).setThemeMode(newValue);
              }
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          // ignore: deprecated_member_use
          RadioListTile<ThemeMode>(
            title: const Text('Sistem'),
            subtitle: Text('Otomatis mengikuti tema perangkat', style: Theme.of(context).textTheme.bodySmall),
            value: ThemeMode.system,
            // ignore: deprecated_member_use
            groupValue: themeProvider.themeMode,
            // ignore: deprecated_member_use
            onChanged: (newValue) {
              if (newValue != null) {
                Provider.of<ThemeProvider>(context, listen: false).setThemeMode(newValue);
              }
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          const Divider(),
          _buildSectionHeader(context, 'Info Akun'),
          ListTile(
            leading: Icon(Icons.person, color: iconColor),
            title: const Text('Profil Pengguna'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          _buildSectionHeader(context, 'Lainnya'),
          ListTile(
            leading: Icon(Icons.info_outline, color: iconColor),
            title: const Text('Tentang Aplikasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'M|S Connectivity',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2024 M|S Connectivity',
                children: <Widget>[
                  const SizedBox(height: 15),
                  const Text('Aplikasi untuk mengelola koneksi internet Anda.'),
                ],
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: iconColor),
            title: const Text('Kebijakan Privasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout, color: iconColor),
            title: const Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
