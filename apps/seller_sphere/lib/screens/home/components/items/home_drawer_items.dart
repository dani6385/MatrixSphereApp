<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
// lib/navigation/widgets/app_drawer_items.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
<<<<<<< HEAD
import 'package:seller_sphere/navigations/app_extractor.dart';
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055

final Logger logger = Logger();

// Definisi struktur data untuk item menu yang kini ditambah properti 'label'
class DrawerItemData {
  final String title;
  final IconData icon;
  final String label; // Properti baru untuk menyimpan keterangan fungsi
<<<<<<< HEAD
  final String route;
=======

>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
  final VoidCallback? onTap;

  DrawerItemData({
    required this.title,
    required this.icon,
    required this.label,
<<<<<<< HEAD
    required this.route,
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
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
<<<<<<< HEAD
      route: AppRoutes.home,
      onTap: () {
        logger.i('Menu Home / Beranda diklik!');
        context.go(AppRoutes.home);
=======
      onTap: () {
        logger.i('Menu Home / Beranda diklik!');
        context.go('/home');
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
      },
    ),
    DrawerItemData(
      title: 'Simulasi',
      icon: Icons.dashboard,
      label:
          'Menampilkan ringkasan statistik penjualan, grafik, dan performa toko.',
<<<<<<< HEAD
      route: '',
      onTap: () {
        logger.i('Memasuki Halaman Simulasi!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const SimulationScreen()),
        );
=======
      onTap: () {
        logger.i('Memasuki Halaman Simulasi!');
        context.push(AppRoutes.simulation);
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
      },
    ),
    DrawerItemData(
      title: 'Status Toko',
      icon: Icons.info_outline,
<<<<<<< HEAD
      label: 'Melihat status persetujuan toko, rating, dan informasi penting lainnya.',
      route: AppRoutes.status, // Placeholder untuk rute yang akan datang
      onTap: () {
        logger.i('Menu Status Toko diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const StatusScreen()),
        );
=======
      label:
          'Melihat status persetujuan toko, rating, dan informasi penting lainnya.',
      onTap: () {
        logger.i('Menu Status Toko diklik!');
        context.push(AppRoutes.status);
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
      },
    ),
    DrawerItemData(
      title: 'Products / Produk',
      icon: Icons.shopping_bag,
      label:
          'Mengelola daftar produk, menambah barang baru, atau mengatur harga.',
<<<<<<< HEAD
      route: '',
      onTap: () {
        logger.i('Menu Products diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const ProductScreen(),
          ),
        );
=======
      onTap: () {
        logger.i('Menu Products diklik!');
        context.push(AppRoutes.publicProduct);
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
      },
    ),
    DrawerItemData(
      title: 'Orders / Pesanan',
      icon: Icons.receipt,
      label: 'Melihat dan memproses pesanan masuk dari pembeli.',
<<<<<<< HEAD
      route: '',
      onTap: () {
        logger.i('Menu Orders diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const OrderScreen(),
          ),
        );
=======
      onTap: () {
        logger.i('Menu Orders diklik!');
        context.push(AppRoutes.order);
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
      },
    ),
    DrawerItemData(
      title: 'Stok Barang / Inventaris',
      icon: Icons.inventory,
      label: 'Memantau ketersediaan stok barang secara mendetail.',
<<<<<<< HEAD
      route: AppRoutes.inventory, // Ganti dengan route yang sesuai
      onTap: () {
        logger.i('Menu Stok Barang diklik!');
        // Pastikan Anda sudah mendaftarkan AppRoutes.inventory di GoRouter
        // Contoh: context.go(AppRoutes.inventory);
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const InventoryScreen()),
        );
=======
      onTap: () {
        logger.i('Menu Stok Barang diklik!');
        context.push(AppRoutes.inventory);
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
      },
    ),
    DrawerItemData(
      title: 'Shopes / Pelanggan',
      icon: Icons.people,
      label: 'Melihat daftar data pembeli atau pelanggan setia toko.',
<<<<<<< HEAD
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
=======
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
      title: 'Dashboard',
      icon: Icons.dashboard,
      label:
          'Menampilkan ringkasan statistik penjualan, grafik, dan performa toko.',
      route: '',
      onTap: () {
        logger.i('Menu Dashboard diklik!');
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
=======
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
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
      },
    ),
    DrawerItemData(
      title: 'Riwayat / Transaksi',
      icon: Icons.payment,
      label: 'Memeriksa riwayat pembayaran atau transaksi yang masuk.',
<<<<<<< HEAD
      route: '',
      onTap: () {
        logger.i('Menu Riwayat diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const HistoryScreen(),// transactionscreen
          ),
        );
=======
      onTap: () {
        logger.i('Menu Riwayat diklik!');
        context.push(AppRoutes.transaction);
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
      },
    ),
    DrawerItemData(
      title: 'Reports / Laporan',
      icon: Icons.bar_chart,
      label: 'Mengakses laporan penjualan harian, bulanan, atau tahunan.',
<<<<<<< HEAD
      route: '',
      onTap: () {
        logger.i('Menu Reports diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const FinancialScreen(),
          ),
        );
=======
      onTap: () {
        logger.i('Menu Reports diklik!');
        context.push(AppRoutes.reports);
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
      },
    ),
    DrawerItemData(
      title: 'Promotions / Promosi',
      icon: Icons.discount,
      label: 'Mengatur diskon, kupon, atau voucher toko.',
<<<<<<< HEAD
      route: '',
      onTap: () {
        logger.i('Menu Promotions diklik!');
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => const SalestScreen(),
          ),
        );
=======
      onTap: () {
        logger.i('Menu Promotions diklik!');
        context.push(AppRoutes.promotions);
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
      },
    ),
  ];
}
<<<<<<< HEAD
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
