// lib/navigation/widgets/app_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'package:seller_sphere/navigations/app_extractor.dart';

final Logger logger = Logger();

// Definisi struktur data untuk item menu yang kini ditambah properti 'label'
class DrawerItemData {
  final String title;
  final IconData icon;
  final String label; // Properti baru untuk menyimpan keterangan fungsi
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

// Daftar seluruh item menu drawer dengan penambahan label fungsi
List<DrawerItemData> getDrawerItems(BuildContext context, String currentRoute) {
  return [
    DrawerItemData(
      title: 'Home / Beranda',
      icon: Icons.home,
      label: 'Mengarahkan pengguna kembali ke halaman utama dashboard.',
      route: AppRoutes.home,
      onTap: () {
        logger.i('Menu Home / Beranda diklik!');
        context.go(AppRoutes.home);
      },
    ),
    DrawerItemData(
      title: 'Simulasi',
      icon: Icons.dashboard,
      label:
          'Menampilkan ringkasan statistik penjualan, grafik, dan performa toko.',
      route: '',
      onTap: () {
        logger.i('Memasuki Halaman Simulasi!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const SimulationScreen()),
        );
      },
    ),
    DrawerItemData(
      title: 'Status Toko',
      icon: Icons.info_outline,
      label: 'Melihat status persetujuan toko, rating, dan informasi penting lainnya.',
      route: AppRoutes.status, // Placeholder untuk rute yang akan datang
      onTap: () {
        logger.i('Menu Status Toko diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const StatusScreen()),
        );
      },
    ),
    DrawerItemData(
      title: 'Products / Produk',
      icon: Icons.shopping_bag,
      label:
          'Mengelola daftar produk, menambah barang baru, atau mengatur harga.',
      route: '',
      onTap: () {
        logger.i('Menu Products diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const ProductScreen(),
          ),
        );
      },
    ),
    DrawerItemData(
      title: 'Orders / Pesanan',
      icon: Icons.receipt,
      label: 'Melihat dan memproses pesanan masuk dari pembeli.',
      route: '',
      onTap: () {
        logger.i('Menu Orders diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const OrderScreen(),
          ),
        );
      },
    ),
    DrawerItemData(
      title: 'Stok Barang / Inventaris',
      icon: Icons.inventory,
      label: 'Memantau ketersediaan stok barang secara mendetail.',
      route: AppRoutes.inventory, // Ganti dengan route yang sesuai
      onTap: () {
        logger.i('Menu Stok Barang diklik!');
        // Pastikan Anda sudah mendaftarkan AppRoutes.inventory di GoRouter
        // Contoh: context.go(AppRoutes.inventory);
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const InventoryScreen()),
        );
      },
    ),
    DrawerItemData(
      title: 'Shopes / Pelanggan',
      icon: Icons.people,
      label: 'Melihat daftar data pembeli atau pelanggan setia toko.',
      route: '',
      onTap: () {
        logger.i('Menu Shopes diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const ShopesScreen(),
          ),
        );
      },
    ),
    DrawerItemData(
      title: 'Riwayat / Transaksi',
      icon: Icons.payment,
      label: 'Memeriksa riwayat pembayaran atau transaksi yang masuk.',
      route: '',
      onTap: () {
        logger.i('Menu Riwayat diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const HistoryScreen(),// transactionscreen
          ),
        );
      },
    ),
    DrawerItemData(
      title: 'Reports / Laporan',
      icon: Icons.bar_chart,
      label: 'Mengakses laporan penjualan harian, bulanan, atau tahunan.',
      route: '',
      onTap: () {
        logger.i('Menu Reports diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const FinancialScreen(),
          ),
        );
      },
    ),
    DrawerItemData(
      title: 'Promotions / Promosi',
      icon: Icons.discount,
      label: 'Mengatur diskon, kupon, atau voucher toko.',
      route: '',
      onTap: () {
        logger.i('Menu Promotions diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const SalestScreen(),
          ),
        );
      },
    ),
  ];
}
