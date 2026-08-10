// lib/navigation/widgets/app_drawer_items.dart[cite: 7]

import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:seller_sphere/navigations/app_extractor.dart';
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
      title: 'Streams',
      icon: Icons.home,
      label: 'Mengarahkan pengguna kembali ke halaman utama dashboard.',
      route: AppRoutes.stream,
      onTap: () {
        logger.i('Menu Keamanan diklik!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigasi ke halaman Keamanan.')),
        );
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const StreamingScreen(streamId: '',)),
        );
      },
    ),
    DrawerItemData(
      title: 'Users / Pengguna',
      icon: Icons.people_alt,
      label:
          'Mengelola daftar akun pengguna atau staf yang memiliki akses ke toko.',
      route: '',
      onTap: () {
        logger.i('Menu Users diklik!');
      },
    ),
    DrawerItemData(
      title: 'Products / Produk',
      icon: Icons.shopping_bag,
      label:
          'Mengelola daftar produk, menambah barang baru, atau mengatur harga.',
      route: '',
      onTap: () {
        logger.i('Menu Products diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const ProductScreen(),
          ),
        );
      },
    ),
    DrawerItemData(
      title: 'Inventory / Stok Barang',
      icon: Icons.inventory,
      label: 'Mengelola ketersediaan dan rincian stok barang di gudang.',
      route: '',
      onTap: () {
        logger.i('Menuju ke halaman Inventory');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const InventoryScreen()),
        );
      },
    ),
    DrawerItemData(
      title: 'Rules / Aturan Hak Akses',
      icon: Icons.admin_panel_settings,
      label: 'Mengatur hak akses dan peran wewenang pengguna dalam sistem.',
      route: '',// AppRoutes.managementRules, // Pastikan rute ini didaftarkan di app_routes.dart
      onTap: () {
        logger.i('Menuju ke halaman Rules / Aturan Hak Akses');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const PermissionsScreen()),
        );
      },
    ),

// 2. Menu Khusus untuk Daftar Karyawan / Staf (Members)
    DrawerItemData(
      title: 'Members / Daftar Karyawan',
      icon: Icons.people_alt,
      label: 'Melihat dan mengelola daftar staf atau karyawan yang terdaftar.',
      route: '',// AppRoutes.managementMembers, // Pastikan rute ini didaftarkan di app_routes.dart
      onTap: () {
        logger.i('Menu Members / Karyawan diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const MemberScreen(),
          ),
        );
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
