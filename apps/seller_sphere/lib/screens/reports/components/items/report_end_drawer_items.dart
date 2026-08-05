// lib/navigations/widgets/app_end_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore: unused_import
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/navigations/app_routes.dart';

// Definisi struktur data untuk item menu EndDrawer dengan tambahan properti 'label'
class EndDrawerItemData {
  final String title;
  final IconData icon;
  final String label; // Keterangan fungsi menu
  final String route;
  final VoidCallback? onTap;

  EndDrawerItemData({
    required this.title,
    required this.icon,
    required this.label,
    required this.route,
    this.onTap,
  });
}

// Daftar rekomendasi item menu EndDrawer khusus saat berada di Halaman Report
List<EndDrawerItemData> getEndDrawerItems(BuildContext context) {
  return [
    EndDrawerItemData(
      title: 'Profile / Profil',
      icon: Icons.person,
      label: 'Melihat dan mengubah informasi profil akun pengelola toko.',
      route: AppRoutes.profile,
      onTap: () => context.go(AppRoutes.profile),
    ),
    EndDrawerItemData(
      title: 'Date Range / Rentang Tanggal',
      icon: Icons.date_range,
      label: 'Memilih periode waktu tertentu untuk menyaring data laporan.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Filter Options / Opsi Filter',
      icon: Icons.filter_list,
      label: 'Menyaring laporan berdasarkan kategori produk, metode bayar, atau status.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Currency Settings / Pengaturan Mata Uang',
      icon: Icons.attach_money,
      label: 'Mengatur format mata uang yang digunakan pada grafik dan laporan.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Notifications Settings / Pengaturan Notifikasi',
      icon: Icons.notifications_active,
      label: 'Mengatur pemberitahuan berkala untuk ringkasan laporan harian/mingguan.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Dark Mode / Mode Gelap',
      icon: Icons.dark_mode,
      label: 'Mengubah tema tampilan aplikasi menjadi mode gelap atau terang.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Help / Bantuan',
      icon: Icons.help_outline,
      label: 'Membaca panduan cara membaca metrik dan analitik laporan penjualan.',
      route: '',
      onTap: () {},
    ),
  ];
}