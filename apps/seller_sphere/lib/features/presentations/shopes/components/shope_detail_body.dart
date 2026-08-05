import 'package:flutter/material.dart';
import 'package:seller_sphere/features/domain/entities/user.dart';

/// Komponen body untuk menampilkan detail informasi pelanggan.
class ShopeDetailBody extends StatelessWidget {
  final User user;

  const ShopeDetailBody({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage:
                      (user.photoURL != null && user.photoURL!.isNotEmpty)
                          ? NetworkImage(user.photoURL!)
                          : null,
                  child: (user.photoURL == null || user.photoURL!.isEmpty)
                      ? Text(
                          user.displayName?.substring(0, 1).toUpperCase() ??
                              'U',
                          style: textTheme.headlineLarge?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.displayName ?? 'Nama Tidak Tersedia',
                  style: textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email ?? 'Email tidak tersedia',
                  style: textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            'Informasi Kontak',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildInfoTile(
            context,
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: user.email ?? '-',
          ),
          _buildInfoTile(
            context,
            icon: Icons.phone_outlined,
            title: 'Nomor Telepon',
            subtitle: 'Belum ditambahkan', // Data dummy
          ),
          const SizedBox(height: 24),
          Text(
            'Riwayat Transaksi',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Text('Belum ada riwayat transaksi.'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}