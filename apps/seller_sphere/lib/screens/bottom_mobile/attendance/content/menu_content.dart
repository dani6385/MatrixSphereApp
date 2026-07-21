import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

class MenuContent extends StatefulWidget {
  const MenuContent({super.key});

  @override
  State<MenuContent> createState() => _MenuContentState();
}

class _MenuContentState extends State<MenuContent> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
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
        ],
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
            Text('Nama Pengguna', style: textTheme.bodyLarge),
            Text('Perusahaan Saat Ini', style: textTheme.bodyMedium),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem(
      BuildContext context, TextTheme textTheme, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: kDarkTextSecondary),
      title: Text(title, style: textTheme.bodyMedium),
      onTap: () {
        // Menutup menu bottom sheet sebelum navigasi
        Navigator.of(context).pop();

        // Memberi jeda singkat agar animasi tutup selesai
        Future.delayed(const Duration(milliseconds: 200), () {
          // Guard clause untuk memastikan widget masih terpasang
          if (!mounted) return;

          switch (title) {
            case 'Profil Saya':
              // Asumsi Anda memiliki rute bernama '/profile'
              context.push('/profile');
              break;
            case 'Ganti Perusahaan':
              // Asumsi Anda memiliki rute bernama '/switch-company'
              context.push('/switch-company');
              break;
          }
        });
      },
    );
  }
}
