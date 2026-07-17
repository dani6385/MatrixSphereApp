import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';

class MenuModel extends StatelessWidget {
  const MenuModel({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: kDarkTextPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Menu Akun',
            style: textTheme.titleMedium,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _buildProfileSection(context, textTheme),
            const SizedBox(height: AppSpacing.lg),
            _buildMenuItem(
                context, textTheme, Icons.person_outline, 'Profil Saya'),
            _buildMenuItem(context, textTheme, Icons.business_center_outlined,
                'Ganti Perusahaan'),
            _buildMenuItem(context, textTheme, Icons.security_outlined,
                'Keamanan & Privasi'),
            _buildThemeMenuItem(context, textTheme),
            const Divider(color: kDarkTextSecondary, height: AppSpacing.xxl),
            _buildMenuItem(
                context, textTheme, Icons.help_outline, 'Pusat Bantuan'),
            _buildMenuItem(
                context, textTheme, Icons.info_outline, 'Tentang Aplikasi'),
            const SizedBox(height: AppSpacing.xxl),
            _buildLogoutButton(context, textTheme),
            const SizedBox(height: AppSpacing.lg),
            _buildAppVersion(textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, TextTheme textTheme) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('images/img_profile-avatar.jpg'),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Matrix Admin', style: textTheme.titleLarge),
            Text('Administrator', style: textTheme.bodyMedium),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: kDarkTextPrimary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMenuItem(
      BuildContext context, TextTheme textTheme, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: textTheme.bodyLarge?.color),
      title: Text(title, style: textTheme.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: kDarkTextSecondary),
      onTap: () {},
    );
  }

  Widget _buildThemeMenuItem(BuildContext context, TextTheme textTheme) {
    return ListTile(
      leading: const Icon(Icons.palette_outlined, color: kDarkTextPrimary),
      title: Text('Ubah Tema', style: textTheme.bodyLarge),
      trailing: const Icon(Icons.chevron_right, color: kDarkTextSecondary),
      onTap: () => _showThemePicker(context),
    );
  }

  void _showThemePicker(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Mengikuti Sistem'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) themeProvider.setThemeMode(value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Terang'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) themeProvider.setThemeMode(value);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Gelap'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (value) {
                if (value != null) themeProvider.setThemeMode(value);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, TextTheme textTheme) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.logout, color: kAlertRed),
      label: Text(
        'Keluar',
        style: textTheme.labelLarge?.copyWith(color: kAlertRed),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: kAlertRed),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _buildAppVersion(TextTheme textTheme) {
    return Center(
      child: Text(
        'Matrix App v1.0.0',
        style: textTheme.bodySmall,
      ),
    );
  }
}
