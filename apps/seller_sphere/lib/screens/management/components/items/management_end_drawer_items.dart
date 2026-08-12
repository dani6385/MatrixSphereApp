
// lib/navigations/widgets/app_end_drawer_items.dart

import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
//import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'package:logger/logger.dart';
import 'package:seller_sphere/navigations/app_extractor.dart';

final Logger logger = Logger();

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

// Daftar rekomendasi item menu EndDrawer khusus saat berada di Halaman Management
List<EndDrawerItemData> getEndDrawerItems(BuildContext context) {
  return [
    EndDrawerItemData(
      title: 'Profil Pengguna',
      icon: Icons.person,
      label: 'Melihat dan mengubah informasi profil akun administrator.',
      route: AppRoutes.userProfile,
      onTap: () {
        logger.i('Menu Profile Toko diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const UserProfileScreen()),
        );
      },
    ),
    EndDrawerItemData(
      title: 'Profil Toko',
      icon: Icons.person,
      label: 'Melihat dan mengubah informasi profil akun administrator.',
      route: AppRoutes.userProfile,
      onTap: () {
        logger.i('Menu Profile Toko diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const ShopProfileScreen()),
        );
      },
    ),
    EndDrawerItemData(
      title: 'Account Management / Kelola Akun',
      icon: Icons.manage_accounts,
      label: 'Mengatur hak akses dan kredensial pengguna sistem.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Data Management / Manajemen Data',
      icon: Icons.data_usage,
      label:
          'Mengelola basis data, penyimpanan, dan pembersihan cache aplikasi.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Backup & Restore / Cadangkan & Pulihkan',
      icon: Icons.backup,
      label: 'Melakukan pencadangan data sistem atau memulihkannya kembali.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Notifications Settings / Pengaturan Notifikasi',
      icon: Icons.notifications_active,
      label:
          'Mengatur preferensi pemberitahuan sistem dan peringatan operasional.',
      route: '',
      onTap: () {
        logger.i('Menu Notifications Settings diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
              builder: (context) => const NotificationSettingScreen()),
        );
      },
    ),
    EndDrawerItemData(
      title: 'Security / Keamanan',
      icon: Icons.security,
      label: 'Mengonfigurasi tingkat keamanan dan enkripsi data sistem.',
      route: '',
      onTap: () {
        logger.i('Menu Security / Keamanan diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const SecurityScreen()),
        );
      },
    ),
    EndDrawerItemData(
      title: 'Debug Info / Informasi Debug',
      icon: Icons.bug_report,
      label:
          'Melihat log kesalahan atau status diagnostik aplikasi untuk pengembang.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Settings / Pengaturan Sistem',
      icon: Icons.settings,
      label: 'Mengubah konfigurasi lanjutan dan preferensi aplikasi.',
      route: '',
      onTap: () {
        logger.i('Menu Security / Keamanan diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const SettingScreen()),
        );
      },
    ),
  ];
}