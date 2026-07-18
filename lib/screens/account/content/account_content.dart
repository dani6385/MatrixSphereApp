import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AccountContent extends StatelessWidget {
  const AccountContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        title: const Text('Akun Saya'),
        backgroundColor: kDarkBackground,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Bagian Informasi Pengguna
          Card(
            color: kDarkSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: kDarkSecondary,
                    child: Icon(Icons.person_outline, size: 40, color: kDarkTextPrimary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Nama Pengguna', // Placeholder
                    style: textTheme.titleLarge?.copyWith(color: kDarkTextPrimary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'user.name@example.com', // Placeholder
                    style: textTheme.bodyMedium?.copyWith(color: kDarkTextSecondary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Tombol Log Keluar
          Card(
            color: kDarkSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.exit_to_app, color: kAlertRed),
              title: Text(
                'Log Keluar',
                style: textTheme.bodyLarge?.copyWith(color: kAlertRed),
              ),
              subtitle: Text(
                'Keluar dari sesi akun Anda saat ini',
                style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary),
              ),
              onTap: () {
                // Logika untuk logout bisa ditambahkan di sini
              },
            ),
          ),
        ],
      ),
    );
  }
}
