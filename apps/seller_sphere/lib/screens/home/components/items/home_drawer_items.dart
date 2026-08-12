// lib/navigation/widgets/app_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:seller_sphere/navigations/app_routes.dart';

final Logger logger = Logger();

// Definisi struktur data untuk item menu yang kini ditambah properti 'label'
class DrawerItemData {
  final String title;
  final IconData icon;
  final String label; // Properti baru untuk menyimpan keterangan fungsi

  final VoidCallback? onTap;

  DrawerItemData({
    required this.title,
    required this.icon,
    required this.label,
    this.onTap,
  });
}

// Daftar seluruh item menu drawer dengan penambahan label fungsi
List<DrawerItemData> getDrawerItems(BuildContext context, String currentRoute) {
  return [
    DrawerItemData(
      title: 'Home / Beranda',
      icon: Icons.home,
      label: 'Mengarahkan pengguna kembali ke halaman utama dashboard.',
      onTap: () {
        logger.i('Menu Home / Beranda diklik!');
        context.go('/home');
      },
    ),
    DrawerItemData(
      title: 'Simulasi',
      icon: Icons.dashboard,
      label:
          'Menampilkan ringkasan statistik penjualan, grafik, dan performa toko.',
      onTap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
      },
    ),
    DrawerItemData(
      title: 'Status Toko',
      icon: Icons.info_outline,
      label:
          'Melihat status persetujuan toko, rating, dan informasi penting lainnya.',
      onTap: () {
        logger.i('Menu Status Toko diklik!');
        context.push(AppRoutes.status);
      },
    ),
    DrawerItemData(
      title: 'Products / Produk',
      icon: Icons.shopping_bag,
      label:
          'Mengelola daftar produk, menambah barang baru, atau mengatur harga.',
      onTap: () {
        logger.i('Menu Products diklik!');
        context.push(AppRoutes.publicProduct);
      },
    ),
    DrawerItemData(
      title: 'Orders / Pesanan',
      icon: Icons.receipt,
      label: 'Melihat dan memproses pesanan masuk dari pembeli.',
      onTap: () {
        logger.i('Menu Orders diklik!');
        context.push(AppRoutes.order);
      },
    ),
    DrawerItemData(
      title: 'Stok Barang / Inventaris',
      icon: Icons.inventory,
      label: 'Memantau ketersediaan stok barang secara mendetail.',
      onTap: () {
        logger.i('Menu Stok Barang diklik!');
        context.push(AppRoutes.inventory);
      },
    ),
    DrawerItemData(
      title: 'Shopes / Pelanggan',
      icon: Icons.people,
      label: 'Melihat daftar data pembeli atau pelanggan setia toko.',
      onTap: () {
        logger.i('Menu Shopes diklik!');
        context.push(AppRoutes.shopes);
      },
    ),
    DrawerItemData(
      title: 'Google MAP',
      icon: Icons.map,
      label: 'Melihat daftar data pembeli atau pelanggan setia toko.',
      onTap: () {
        logger.i('Menu MAP diklik!');
        context.push(AppRoutes.map);
      },
    ),
    DrawerItemData(
      title: 'Riwayat / Transaksi',
      icon: Icons.payment,
      label: 'Memeriksa riwayat pembayaran atau transaksi yang masuk.',
      onTap: () {
        logger.i('Menu Riwayat diklik!');
        context.push(AppRoutes.transaction);
      },
    ),
    DrawerItemData(
      title: 'Reports / Laporan',
      icon: Icons.bar_chart,
      label: 'Mengakses laporan penjualan harian, bulanan, atau tahunan.',
      onTap: () {
        logger.i('Menu Reports diklik!');
        context.push(AppRoutes.reports);
      },
    ),
    DrawerItemData(
      title: 'Promotions / Promosi',
      icon: Icons.discount,
      label: 'Mengatur diskon, kupon, atau voucher toko.',
      onTap: () {
        logger.i('Menu Promotions diklik!');
        context.push(AppRoutes.promotions);
      },
    ),
  ];
}
