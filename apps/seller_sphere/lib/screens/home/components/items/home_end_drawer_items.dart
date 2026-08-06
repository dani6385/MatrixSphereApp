// lib/navigations/widgets/app_end_drawer_items.dart

import 'package:flutter/material.dart';


import 'package:seller_sphere/navigations/app_extractor.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

// Definisi struktur data untuk item menu EndDrawer yang ditambah properti 'label'
class EndDrawerItemData {
  final String title;
  final IconData icon;
  final String label; // Properti untuk menyimpan keterangan fungsi
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

// Daftar rekomendasi item menu EndDrawer khusus saat di Halaman Home
List<EndDrawerItemData> getEndDrawerItems(BuildContext context) {
  return [
    EndDrawerItemData(
      title: 'Profile',
      icon: Icons.person,
      label: 'Melihat dan mengubah informasi profil akun toko.',
      route: AppRoutes.profile,
      onTap: () {
        logger.i('Menu Status Toko diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      },
    ),
    EndDrawerItemData(
      title: 'Dark Mode',
      icon: Icons.dark_mode,
      label: 'Mengubah tema tampilan aplikasi menjadi mode gelap atau terang.',
      route: '',
      onTap: () {
        // Aksi mengubah tema
      },
    ),
    EndDrawerItemData(
      title: 'Notifications',
      icon: Icons.notifications_active,
      label: 'Mengatur pemberitahuan pesanan masuk dan pesan pembeli.',
      route: '',
      onTap: () {
        logger.i('Menu Notifikasi diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const NotificationScreen()),
        );
      },
    ),
    EndDrawerItemData(
      title: 'Settings',
      icon: Icons.settings,
      label: 'Mengatur preferensi dasar aplikasi secara keseluruhan.',
      route: AppRoutes.settings,
      onTap: () {
        logger.i('Menu Settings diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const SettingScreen()),
        );
      },
    ),
    EndDrawerItemData(
      title: 'Security',
      icon: Icons.security,
      label: 'Mengatur kata sandi dan keamanan akun seller.',
      route: '',
      onTap: () {
        logger.i('Menu Keamanan diklik!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigasi ke halaman Keamanan.')),
        );
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const SecurityScreen()),
        );
      },
    ),
    EndDrawerItemData(
      title: 'Help',
      icon: Icons.help_outline,
      label: 'Membaca panduan penggunaan atau menghubungi pusat bantuan.',
      route: '',
      onTap: () {
        logger.i('Menu Keamanan diklik!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigasi ke halaman Keamanan.')),
        );
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const HelpScreen()),
        );
      },
    ),
    EndDrawerItemData(
      title: 'About',
      icon: Icons.info_outline,
      label: 'Melihat informasi versi dan pengembang aplikasi.',
      route: '',
      onTap: () {
        logger.i('Menu Status Toko diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const AboutScreen()),
        );
      },
    ),
    EndDrawerItemData(
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
