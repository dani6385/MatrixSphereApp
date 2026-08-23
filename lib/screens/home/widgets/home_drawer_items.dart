// lib/navigation/widgets/app_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Tambahkan go_router untuk navigasi
import 'package:logger/logger.dart';
import 'package:shared_ui/shared_ui.dart'; // Impor shared_ui agar kita bisa menggunakan SideMenuItem

final Logger logger = Logger();

// Definisi struktur data untuk item menu lokal
class MenuDrawer {
  final String title;
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  MenuDrawer({
    required this.title,
    required this.icon,
    required this.label,
    this.onTap,
  });
}

// Daftar seluruh item menu drawer lokal
List<MenuDrawer> getDrawerItems(BuildContext context, String currentRoute) {
  return [
    MenuDrawer(
      title: 'Home / Beranda',
      icon: Icons.home,
      label: 'Mengarahkan pengguna kembali ke halaman utama dashboard.',
      onTap: () => context.go('/'), // Contoh navigasi menggunakan GoRouter
    ),
    MenuDrawer(
      title: 'Simulasi',
      icon: Icons.dashboard,
      label: 'Menampilkan ringkasan statistik penjualan, grafik, dan performa toko.',
      onTap: () => logger.i('Simulasi tapped'),
    ),
    MenuDrawer(
      title: 'Status Toko',
      icon: Icons.info_outline,
      label: 'Melihat status persetujuan toko, rating, dan informasi penting lainnya.',
      onTap: () => logger.i('Status Toko tapped'),
    ),
    MenuDrawer(
      title: 'Products / Produk',
      icon: Icons.shopping_bag,
      label: 'Mengelola daftar produk, menambah barang baru, atau mengatur harga.',
      onTap: () => logger.i('Products tapped'),
    ),
    MenuDrawer(
      title: 'Orders / Pesanan',
      icon: Icons.receipt,
      label: 'Melihat dan memproses pesanan masuk dari pembeli.',
      onTap: () => logger.i('Orders tapped'),
    ),
    MenuDrawer(
      title: 'Stok Barang / Inventaris',
      icon: Icons.inventory,
      label: 'Memantau ketersediaan stok barang secara mendetail.',
      onTap: () => logger.i('Inventory tapped'),
    ),
    MenuDrawer(
      title: 'Shopes / Pelanggan',
      icon: Icons.people,
      label: 'Melihat daftar data pembeli atau pelanggan setia toko.',
      onTap: () => logger.i('Customers tapped'),
    ),
    MenuDrawer(
      title: 'Google MAP',
      icon: Icons.map,
      label: 'Melihat lokasi toko di peta.',
      onTap: () => logger.i('Google MAP tapped'),
    ),
    MenuDrawer(
      title: 'Riwayat / Transaksi',
      icon: Icons.payment,
      label: 'Memeriksa riwayat pembayaran atau transaksi yang masuk.',
      onTap: () => logger.i('Transactions tapped'),
    ),
    MenuDrawer(
      title: 'Reports / Laporan',
      icon: Icons.bar_chart,
      label: 'Mengakses laporan penjualan harian, bulanan, atau tahunan.',
      onTap: () => logger.i('Reports tapped'),
    ),
    MenuDrawer(
      title: 'Promotions / Promosi',
      icon: Icons.discount,
      label: 'Mengatur diskon, kupon, atau voucher toko.',
      onTap: () => logger.i('Promotions tapped'),
    ),
  ];
}

/// Fungsi helper untuk mengubah MenuDrawer lokal menjadi SideMenuItem shared_ui
List<SideMenuItem> getDrawerSideMenuItems(BuildContext context, String currentRoute) {
  final drawerItems = getDrawerItems(context, currentRoute);

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