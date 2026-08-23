// lib/navigations/widgets/app_end_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_ui/shared_ui.dart';

final Logger logger = Logger();

// Definisi struktur data untuk item menu EndDrawer yang ditambah properti 'label'
class MenuDrawer {
  final String title;
  final IconData icon;
  final String label; // Properti untuk menyimpan keterangan fungsi
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

// Daftar rekomendasi item menu EndDrawer khusus saat di Halaman Home
List<MenuDrawer> getEndDrawerItems(BuildContext context, String currentRoute) {
  return [
    MenuDrawer(
      title: 'Profile',
      icon: Icons.person,
      label: 'Melihat dan mengubah informasi profil akun toko.',
      route: '/user-profile',
      onTap: () {},
    ),
    MenuDrawer(
      title: 'Dark Mode',
      icon: Icons.dark_mode,
      label: 'Mengubah tema tampilan aplikasi menjadi mode gelap atau terang.',
      route: '',
      onTap: () {
        // Aksi mengubah tema
      },
    ),
    MenuDrawer(
      title: 'Notifications',
      icon: Icons.notifications_active,
      label: 'Mengatur pemberitahuan pesanan masuk dan pesan pembeli.',
      route: '',
      onTap: () {},
    ),
    MenuDrawer(
      title: 'Settings',
      icon: Icons.settings,
      label: 'Mengatur preferensi dasar aplikasi secara keseluruhan.',
      route: '/setting',
      onTap: () {},
    ),
    MenuDrawer(
      title: 'Security',
      icon: Icons.security,
      label: 'Mengatur kata sandi dan keamanan akun seller.',
      route: '',
      onTap: () {},
    ),
    MenuDrawer(
      title: 'Help',
      icon: Icons.help_outline,
      label: 'Membaca panduan penggunaan atau menghubungi pusat bantuan.',
      route: '',
      onTap: () {},
    ),
    MenuDrawer(
      title: 'About',
      icon: Icons.info_outline,
      label: 'Melihat informasi versi dan pengembang aplikasi.',
      route: '',
      onTap: () {},
    ),
    MenuDrawer(
      title: 'Logout',
      icon: Icons.logout,
      label: 'Keluar dari sesi akun aktif pada aplikasi.',
      route: '',
      onTap: () {
        // Aksi keluar akun
      },
    ),
  ];
}

List<SideMenuItem> getEndDrawerSideMenuItems(BuildContext context, String currentRoute) {
  final drawerItems = getEndDrawerItems(context, currentRoute);

  return drawerItems.map((item) {
    return SideMenuItem(
      title: item.title,
      icon: item.icon,
      label: item.label,
      route: '', // Sesuaikan rute jika diperlukan
      isSelected: false,
      onTap: item.onTap ?? () {}, // Provide an empty function if item.onTap is null
    );
  }).toList();
}