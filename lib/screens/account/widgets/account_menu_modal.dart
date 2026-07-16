import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AccountMenuModal extends StatelessWidget {
  const AccountMenuModal({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121),
        elevation: 0,
        title: Text('Menu Akun',
            style: textTheme.titleLarge?.copyWith(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('images/img_profile-avatar.jpg'),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Matrix Admin',
                style: textTheme.titleLarge?.copyWith(color: Colors.white)),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: kBlueSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Super Administrator',
                  style:
                      textTheme.bodyMedium?.copyWith(color: kDarkTextSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildMenuItem(context,
                icon: Icons.person_outline,
                title: 'Profil Pengguna',
                subtitle: 'Informasi detail akun'),
            _buildMenuItem(context,
                icon: Icons.cloud_sync_outlined,
                title: 'Sinkronisasi Cloud',
                subtitle: 'Status koneksi Firebase'),
            _buildMenuItem(context,
                icon: Icons.brightness_6_outlined,
                title: 'Ubah Tema',
                subtitle: 'Mode Gelap Aktif'),
            const Spacer(),
            _buildLogoutButton(context),
            const SizedBox(height: AppSpacing.md),
            Text('Matrix Sphere v1.4.2',
                style: textTheme.bodySmall
                    ?.copyWith(color: kDarkTextSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle}) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(icon, color: kDarkTextSecondary),
      title: Text(title,
          style: textTheme.bodyLarge?.copyWith(color: Colors.white)),
      subtitle: Text(subtitle,
          style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary)),
      onTap: () {},
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Card(
      color:
          const Color.fromARGB(255, 66, 66, 66), // Warna latar belakang kartu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Mengatur radius sudut
      ),
      child: ListTile(
        leading: const Icon(Icons.exit_to_app,
            color: kAlertRed), // Warna ikon
        title: Text(
          'Log Keluar',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: kAlertRed, // Warna teks
              ),
        ),
        subtitle: Text(
          'Sesi akun Anda',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: kDarkTextSecondary, // Warna subjudul
              ),
        ),
        onTap: () {
          // Aksi saat tombol ditekan
        },
      ),
    );
  }
}
