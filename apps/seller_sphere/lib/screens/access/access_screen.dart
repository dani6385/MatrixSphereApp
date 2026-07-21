import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/routes/app_routes.dart';

class AccessScreen extends StatelessWidget {
  const AccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        title: const Text('Akses Karyawan'),
        backgroundColor: kDarkAppBar,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildAccessCard(
            context: context,
            icon: Icons.input,
            title: 'Input Barang',
            subtitle: 'Mencatat barang yang masuk ke gudang.',
            color: kAccentBlue,
            onTap: () {
              // Navigasi ke halaman input barang (perlu dibuat)
              context.push(AppRoutes.goodsIn);
            },
          ),
          const SizedBox(height: 16),
          _buildAccessCard(
            context: context,
            icon: Icons.inventory_2,
            title: 'Kelola Stok',
            subtitle: 'Melihat dan mengelola stok barang saat ini.',
            color: kAccentPurple,
            onTap: () {
              // Navigasi ke halaman kelola stok (perlu dibuat)
              context.push(AppRoutes.manageStock);
            },
          ),
          const SizedBox(height: 16),
          _buildAccessCard(
            context: context,
            icon: Icons.output,
            title: 'Pengeluaran Barang',
            subtitle: 'Mencatat barang yang keluar dari gudang.',
            color: kWarmOrange,
            onTap: () {
              // Navigasi ke halaman pengeluaran barang (perlu dibuat)
              context.push(AppRoutes.goodsOut);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccessCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      color: kDarkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(icon, size: 40, color: color),
        title: Text(title, style: const TextStyle(color: kDarkTextPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle, style: const TextStyle(color: kDarkTextSecondary)),
        onTap: onTap,
      ),
    );
  }
}