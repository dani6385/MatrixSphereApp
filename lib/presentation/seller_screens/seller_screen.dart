import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:shared_ui/shared_ui.dart';

/// Layar utama untuk bagian "Seller".
///
/// Layar ini berfungsi sebagai hub untuk fitur-fitur yang berkaitan dengan
/// manajemen penjual, seperti melihat status pendaftaran atau mengakses
/// dasbor penjual jika sudah disetujui.
class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Area Penjual'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 80,
                color: colorScheme.secondary,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Kelola Pendaftaran Anda',
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Lihat status pendaftaran toko Anda atau kelola toko Anda jika sudah disetujui.',
                style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xlg),
              ElevatedButton.icon(
                icon: const Icon(Icons.list_alt_rounded),
                label: const Text('Lihat Daftar Pendaftaran'),
                onPressed: () {
                  // Navigasi ke halaman yang menampilkan daftar pendaftaran
                  context.push('/seller-registrations');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}