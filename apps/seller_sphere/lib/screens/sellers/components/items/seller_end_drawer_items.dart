// lib/navigations/widgets/app_end_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// ignore: unused_import
import 'package:shared_ui/shared_ui.dart';

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

// Daftar rekomendasi item menu EndDrawer khusus saat berada di Halaman Seller
List<EndDrawerItemData> getEndDrawerItems(BuildContext context) {
  return [
    EndDrawerItemData(
      title: 'Profile / Profil',
      icon: Icons.person,
      label: 'Melihat dan mengubah informasi profil akun penjual.',
      route: '/user-profile',
      onTap: () => context.go('/user-profile'),
    ),
    EndDrawerItemData(
      title: 'Payment Methods / Metode Pembayaran',
      icon: Icons.payment,
      label: 'Mengatur rekening bank atau dompet digital untuk pencairan dana toko.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Order History / Riwayat Pesanan',
      icon: Icons.history,
      label: 'Melihat catatan transaksi dan pesanan yang telah selesai.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Addresses / Alamat Toko',
      icon: Icons.location_on,
      label: 'Mengelola alamat lokasi penjemputan barang atau gudang toko.',
      route: '',
      onTap: () {},
    ),
    EndDrawerItemData(
      title: 'Notifications Settings / Pengaturan Notifikasi',
      icon: Icons.notifications_active,
      label: 'Mengatur pemberitahuan masuk untuk pesanan dan pesan pembeli.',
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
      label: 'Membaca panduan operasional atau menghubungi pusat layanan seller.',
      route: '',
      onTap: () {},
    ),
  ];
}