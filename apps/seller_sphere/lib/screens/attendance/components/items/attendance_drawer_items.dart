// lib/navigation/widgets/app_drawer_items.dart[cite: 9]

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

// Daftar rekomendasi item menu Drawer khusus saat berada di Halaman Attendance
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
      title: 'Attendance History / Riwayat Kehadiran',
      icon: Icons.history,
      label: 'Melihat catatan riwayat jam masuk dan jam keluar presensi.',
      route: '',
      onTap: () {
        logger.i('Menu Attendance History diklik!');
      },
    ),
    DrawerItemData(
      title: 'Work Calendar / Kalender Kerja',
      icon: Icons.calendar_today,
      label: 'Memeriksa jadwal shift kerja, hari libur, dan jadwal cuti.',
      route: '',
      onTap: () {
        logger.i('Menu Work Calendar diklik!');
      },
    ),
    DrawerItemData(
      title: 'Tasks / Tugas Harian',
      icon: Icons.task,
      label: 'Melihat daftar tugas atau target kerja harian yang harus diselesaikan.',
      route: '',
      onTap: () {
        logger.i('Menu Tasks diklik!');
      },
    ),
    DrawerItemData(
      title: 'Calendar / Kalender',
      icon: Icons.event,
      label: 'Melihat agenda kegiatan atau acara operasional secara keseluruhan.',
      route: '',
      onTap: () {
        logger.i('Menu Calendar diklik!');
      },
    ),
    DrawerItemData(
      title: 'Profile / Profil',
      icon: Icons.person,
      label: 'Melihat dan mengubah informasi profil akun staf atau karyawan.',
      route: '/user-prfile',
      onTap: () {
        logger.i('Menu Profile diklik!');
        context.go(AppRoutes.userProfile);
      },
    ),
  ];
}