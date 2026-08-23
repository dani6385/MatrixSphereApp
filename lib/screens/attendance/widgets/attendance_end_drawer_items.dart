// lib/navigations/widgets/app_end_drawer_items.dart[cite: 9]

import 'package:flutter/material.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_models/models/office_location_model.dart';
import 'package:shared_navigations/shared_navigations.dart';
import 'package:shared_ui/shared_ui.dart';

// Definisi struktur data untuk item menu EndDrawer dengan tambahan properti 'label'
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

// Daftar rekomendasi item menu EndDrawer khusus saat berada di Halaman Attendance
List<MenuDrawer> getEndDrawerItems(BuildContext context, String currentRoute) {
  return [
    MenuDrawer(
      title: 'Profile / Profil',
      icon: Icons.person,
      label: 'Melihat dan mengubah informasi profil akun staf atau karyawan.',
      route: '/user-profile',
      onTap: () => context.go(AppRoutes.userProfile),
    ),
    MenuDrawer(
      title: 'Attendance History / Riwayat Kehadiran',
      icon: Icons.history,
      label: 'Melihat catatan riwayat jam masuk dan jam keluar presensi.',
      route: '',
      onTap: () {},
    ),
    MenuDrawer(
      title: 'Work Calendar / Kalender Kerja',
      icon: Icons.calendar_today,
      label: 'Memeriksa jadwal shift kerja, hari libur, dan jadwal cuti.',
      route: '',
      onTap: () {},
    ),
    MenuDrawer(
      title: 'Tasks / Tugas Harian',
      icon: Icons.task,
      label:
          'Melihat daftar tugas atau target kerja harian yang harus diselesaikan.',
      route: '',
      onTap: () {},
    ),
    MenuDrawer(
      title: 'Notifications Settings / Pengaturan Notifikasi',
      icon: Icons.notifications_active,
      label: 'Mengatur pengingat waktu jam masuk dan jam pulang kerja.',
      route: '',
      onTap: () {},
    ),
    MenuDrawer(
      title: 'Dark Mode / Mode Gelap',
      icon: Icons.dark_mode,
      label: 'Mengubah tema tampilan aplikasi menjadi mode gelap atau terang.',
      route: '',
      onTap: () {},
    ),
    MenuDrawer(
      title: 'Help / Bantuan',
      icon: Icons.help_outline,
      label:
          'Membaca panduan tata cara melakukan presensi atau menghubungi HR.',
      route: '',
      onTap: () {},
    ),
  ];
}

List<SideMenuItem> getEndDrawerSideMenuItems(
    BuildContext context, String currentRoute,
    {required OfficeLocationModel officeLocation, Position? currentPosition}) {
  final drawerItems = getEndDrawerItems(context, currentRoute);

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
