import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final Color iconColor = isDarkMode ? Colors.white : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          _buildSectionHeader(context, 'Tampilan'),
          SwitchListTile(
            title: const Text('Mode Gelap'),
            value: isDarkMode,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            secondary: Icon(Icons.dark_mode, color: iconColor),
            activeTrackColor: Theme.of(context).colorScheme.primary.withAlpha(128), // 128 is ~50% opacity
            thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Theme.of(context).colorScheme.primary;
              }
              return Colors.grey;
            }),
          ),
          const Divider(),
          _buildSectionHeader(context, 'Info Akun'),
          ListTile(
            leading: Icon(Icons.person, color: iconColor),
            title: const Text('Profil Pengguna'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to profile screen
            },
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
                    applicationName: 'Hotspot Client',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2024 M|S Connectivity',
                    children: <Widget>[
                        const SizedBox(height: 15),
                        const Text('Aplikasi untuk mengelola koneksi hotspot Anda.')
                    ],
                );
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip, color: iconColor),
            title: const Text('Kebijakan Privasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to privacy policy screen
            },
          ),
            ListTile(
            leading: Icon(Icons.logout, color: iconColor),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout
            },
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
          color: Theme.of(context).colorScheme.primary
        ),
      ),
    );
  }
}
