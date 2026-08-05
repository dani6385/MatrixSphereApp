// lib/navigation/widgets/app_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:seller_sphere/navigations/app_routes.dart';

final Logger logger = Logger();

// Definisi struktur data untuk item menu dengan tambahan properti 'label'
class DrawerItemData {
  final String title;
  final IconData icon;
  final String label; // Keterangan fungsi menu
  final String route;
  final VoidCallback? onTap;

  DrawerItemData({
    required this.title,
    required this.icon,
    required this.label,
    required this.route,
    this.onTap,
  });
}

// Daftar rekomendasi item menu Drawer khusus saat berada di Halaman Report
List<DrawerItemData> getDrawerItems(BuildContext context, String currentRoute) {
  return [
    DrawerItemData(
      title: 'Home / Beranda',
      icon: Icons.home,
      label: 'Mengarahkan pengguna kembali ke halaman utama dashboard.',
      route: AppRoutes.home,
      onTap: () => context.go(AppRoutes.home),
    ),
    DrawerItemData(
      title: 'Sales Summary / Ringkasan Penjualan',
      icon: Icons.bar_chart,
      label: 'Melihat rekapitulasi pendapatan harian, mingguan, dan bulanan.',
      route: '',
      onTap: () {
        logger.i('Menu Sales Summary diklik!');
      },
    ),
    DrawerItemData(
      title: 'Transaction History / Riwayat Transaksi',
      icon: Icons.receipt_long,
      label: 'Melihat catatan lengkap seluruh transaksi penjualan yang berhasil.',
      route: '',
      onTap: () {
        logger.i('Menu Transaction History diklik!');
      },
    ),
    DrawerItemData(
      title: 'Top Products / Produk Terlaris',
      icon: Icons.trending_up,
      label: 'Memeriksa daftar produk yang paling banyak dibeli oleh pelanggan.',
      route: '',
      onTap: () {
        logger.i('Menu Top Products diklik!');
      },
    ),
    DrawerItemData(
      title: 'Export Data / Unduh Laporan',
      icon: Icons.download,
      label: 'Mengunduh laporan keuangan dan penjualan dalam format Excel atau PDF.',
      route: '',
      onTap: () {
        logger.i('Menu Export Data diklik!');
      },
    ),
    DrawerItemData(
      title: 'Profile / Profil',
      icon: Icons.person,
      label: 'Melihat dan mengubah informasi profil akun pengelola toko.',
      route: AppRoutes.profile,
      onTap: () {
        logger.i('Menu Profile diklik!');
        context.go(AppRoutes.profile);
      },
    ),
  ];
}