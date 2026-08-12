// lib/navigations/widgets/app_end_drawer_items.dart[cite: 9]

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

// Daftar rekomendasi item menu EndDrawer khusus saat berada di Halaman Attendance
List<EndDrawerItemData> getEndDrawerItems(BuildContext context) {
  return [
    EndDrawerItemData(
      title: 'Profile / Profil',
      icon: Icons.person,
      label: 'Melihat dan mengubah informasi profil akun staf atau karyawan.',
      route: AppRoutes.userProfile,
      onTap: () => context.go(AppRoutes.userProfile),
    ),
    EndDrawerItemData(
      title: 'Attendance History / Riwayat Kehadiran',
      icon: Icons.history,
      label: 'Melihat catatan riwayat jam masuk dan jam keluar presensi.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Work Calendar / Kalender Kerja',
      icon: Icons.calendar_today,
      label: 'Memeriksa jadwal shift kerja, hari libur, dan jadwal cuti.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Tasks / Tugas Harian',
      icon: Icons.task,
      label: 'Melihat daftar tugas atau target kerja harian yang harus diselesaikan.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Notifications Settings / Pengaturan Notifikasi',
      icon: Icons.notifications_active,
      label: 'Mengatur pengingat waktu jam masuk dan jam pulang kerja.',
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
      label: 'Membaca panduan tata cara melakukan presensi atau menghubungi HR.',
      route: '',
      onTap: () {},
    ),
  ];
}