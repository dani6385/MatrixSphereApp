// lib/navigation/widgets/app_drawer_items.dart[cite: 7]

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

// Daftar rekomendasi item menu Drawer khusus saat berada di Halaman Management
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
      title: 'Users / Pengguna',
      icon: Icons.people_alt,
      label: 'Mengelola daftar akun pengguna atau staf yang memiliki akses ke toko.',
      route: '',
      onTap: () {
        logger.i('Menu Users diklik!');
      },
    ),
    DrawerItemData(
      title: 'Roles & Permissions / Hak Akses',
      icon: Icons.assignment_ind,
      label: 'Mengatur peran dan batasan hak akses untuk setiap pengguna.',
      route: '',
      onTap: () {
        logger.i('Menu Roles diklik!');
      },
    ),
    DrawerItemData(
      title: 'Inventory / Stok Barang',
      icon: Icons.inventory,
      label: 'Mengelola ketersediaan dan rincian stok barang di gudang.',
      route: '',
      onTap: () {
        logger.i('Menu Inventory diklik!');
      },
    ),
    DrawerItemData(
      title: 'Vendors / Pemasok',
      icon: Icons.store,
      label: 'Mengelola data vendor atau pemasok barang toko.',
      route: '',
      onTap: () {
        logger.i('Menu Vendors diklik!');
      },
    ),
    DrawerItemData(
      title: 'Audit Log / Riwayat Aktivitas',
      icon: Icons.history,
      label: 'Memantau catatan riwayat aktivitas dan perubahan data sistem.',
      route: '',
      onTap: () {
        logger.i('Menu Audit Log diklik!');
      },
    ),
    DrawerItemData(
      title: 'Settings / Pengaturan',
      icon: Icons.settings,
      label: 'Mengatur konfigurasi utama sistem aplikasi.',
      route: '',
      onTap: () {
        logger.i('Menu Settings diklik!');
      },
    ),
  ];
}