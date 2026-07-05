import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

/// Layar yang ditampilkan kepada pengguna di aplikasi utama (shop_sphere)
/// untuk mengajak mereka mendaftarkan tokonya ke aplikasi penjual (seller_sphere).
class UserApropScreen extends StatelessWidget {
  const UserApropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mitra Seller Sphere'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront_outlined,
              size: 100,
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Kembangkan Usaha Anda Bersama Kami',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Daftarkan warung atau toko Anda sebagai mitra di Seller Sphere dan nikmati berbagai keuntungan untuk memajukan bisnis Anda.',
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xlg),
            _buildBenefitItem(
              context,
              icon: Icons.people_alt_outlined,
              title: 'Jangkauan Pelanggan Luas',
              description:
                  'Produk Anda akan dilihat oleh ribuan pengguna aplikasi kami.',
            ),
            const SizedBox(height: AppSpacing.md + AppSpacing.xxs), // 16 + 4 = 20
            _buildBenefitItem(
              context,
              icon: Icons.inventory_2_outlined,
              title: 'Manajemen Pesanan Mudah',
              description:
                  'Kelola stok, pesanan, dan pengiriman dalam satu aplikasi khusus.',
            ),
            const SizedBox(height: AppSpacing.md + AppSpacing.xxs), // 16 + 4 = 20
            _buildBenefitItem(
              context,
              icon: Icons.insights_outlined,
              title: 'Analisis Penjualan',
              description:
                  'Dapatkan laporan penjualan untuk membantu strategi bisnis Anda.',
            ),
            const SizedBox(height: AppSpacing.xxlg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Daftar Sekarang'),
                onPressed: () {
                  // Navigasi ke halaman formulir pendaftaran mitra.
                  context.push('/register-seller');
                },
                // Gaya sudah diatur secara global di AppTheme, tidak perlu di-override di sini
                // kecuali jika ada kebutuhan spesifik.
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary), // Sudah benar
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }
}