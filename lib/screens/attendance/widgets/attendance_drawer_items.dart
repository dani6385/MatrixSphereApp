// lib/navigation/widgets/app_drawer_items.dart[cite: 9]

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_navigations/shared_navigations.dart';
import 'package:shared_ui/shared_ui.dart';

final Logger logger = Logger();

List<SideMenuItem> getDrawerSideMenuItems(
    BuildContext context, String currentRoute) {
  final drawerItems = getDrawerItems(context, currentRoute);

  return drawerItems.map((item) {
    return SideMenuItem(
      title: item.title,
      icon: item.icon,
      label: item.label,
      route: '', // Sesuaikan rute jika diperlukan
      isSelected: false,
      onTap: item.onTap ??
          () {}, // Provide an empty function if item.onTap is null
    );
  }).toList();
}

// Definisi struktur data untuk item menu dengan tambahan properti 'label'
class MenuDrawer {
  final String title;
  final IconData icon;
  final String label; // Keterangan fungsi menu
  final String route;
  final VoidCallback? onTap;

  MenuDrawer({
    required this.title,
    required this.icon,
    required this.label,
    required this.route,
    this.onTap,
  });
}

// Daftar rekomendasi item menu Drawer khusus saat berada di Halaman Attendance
List<MenuDrawer> getDrawerItems(BuildContext context,String currentRoute) {
  return [
    MenuDrawer(
      title: 'Home / Beranda',
      icon: Icons.home,
      label: 'Mengarahkan pengguna kembali ke halaman utama dashboard.',
      route: AppRoutes.home,
      onTap: () {
        logger.i('Navigasi ke Home');
        AppNavigation.goToTab(context, AppRoutes.caseOScreen);
      },
    ),
    MenuDrawer(
      title: 'Attendance History / Riwayat Kehadiran',
      icon: Icons.history,
      label: 'Melihat catatan riwayat jam masuk dan jam keluar presensi.',
      route: '',
      onTap: () {
        logger.i('Menu Attendance History diklik!');
      },
    ),
    MenuDrawer(
      title: 'Work Calendar / Kalender Kerja',
      icon: Icons.calendar_today,
      label: 'Memeriksa jadwal shift kerja, hari libur, dan jadwal cuti.',
      route: '',
      onTap: () {
        logger.i('Menu Work Calendar diklik!');
      },
    ),
    MenuDrawer(
      title: 'Tasks / Tugas Harian',
      icon: Icons.task,
      label:
          'Melihat daftar tugas atau target kerja harian yang harus diselesaikan.',
      route: '',
      onTap: () {
        logger.i('Menu Tasks diklik!');
      },
    ),
    MenuDrawer(
      title: 'Calendar / Kalender',
      icon: Icons.event,
      label:
          'Melihat agenda kegiatan atau acara operasional secara keseluruhan.',
      route: '',
      onTap: () {
        logger.i('Menu Calendar diklik!');
      },
    ),
    MenuDrawer(
      title: 'Profile / Profil',
      icon: Icons.person,
      label: 'Melihat dan mengubah informasi profil akun staf atau karyawan.',
      route: AppRoutes.userProfile,
      onTap: () {
        logger.i('Navigasi ke User Profile');
        AppNavigation.pushToUserProfile(context);
      },
    ),
  ];
}
