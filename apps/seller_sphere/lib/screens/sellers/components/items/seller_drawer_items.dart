// lib/navigation/widgets/app_drawer_items.dart[cite: 9]

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:seller_sphere/navigations/app_routes.dart';

final Logger logger = Logger();

// Definisi struktur data untuk item menu dengan tambahan properti 'label'
class DrawerItemData {
  final String title;
  final IconData icon;
  final String label; // Keterangan fungsi menu
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

// Daftar rekomendasi item menu Drawer khusus saat berada di Halaman Seller
List<DrawerItemData> getDrawerItems(BuildContext context, String currentRoute) {
  return [
    DrawerItemData(
      title: 'Home / Beranda',
      icon: Icons.home,
      label: 'Mengarahkan pengguna kembali ke halaman utama dashboard.',
      route: AppRoutes.home,
      onTap: () => context.go(AppRoutes.home),
    ),
    DrawerItemData(
      title: 'Products / Produk',
      icon: Icons.shopping_bag,
      label: 'Mengelola daftar produk, menambah barang baru, atau mengubah harga.',
      route: '',
      onTap: () {
        logger.i('Menu Products diklik!');
      },
    ),
    DrawerItemData(
      title: 'Orders / Pesanan',
      icon: Icons.receipt,
      label: 'Melihat dan memproses pesanan masuk dari pembeli.',
      route: '',
      onTap: () {
        logger.i('Menu Orders diklik!');
      },
    ),
    DrawerItemData(
      title: 'Inventory / Stok Barang',
      icon: Icons.inventory,
      label: 'Memantau ketersediaan stok barang secara mendetail.',
      route: '',
      onTap: () {
        logger.i('Menu Inventory diklik!');
      },
    ),
    DrawerItemData(
      title: 'Shipping / Pengiriman',
      icon: Icons.local_shipping,
      label: 'Mengatur pengiriman pesanan dan resi pengiriman barang.',
      route: '',
      onTap: () {
        logger.i('Menu Shipping diklik!');
      },
    ),
    DrawerItemData(
      title: 'Promotions / Promosi',
      icon: Icons.campaign,
      label: 'Mengatur diskon, kupon, atau kampanye pemasaran toko.',
      route: '',
      onTap: () {
        logger.i('Menu Promotions diklik!');
      },
    ),
    DrawerItemData(
      title: 'Reviews / Ulasan',
      icon: Icons.reviews,
      label: 'Melihat penilaian dan ulasan produk dari para pembeli.',
      route: '',
      onTap: () {
        logger.i('Menu Reviews diklik!');
      },
    ),
    DrawerItemData(
      title: 'Payments / Pembayaran',
      icon: Icons.payment,
      label: 'Memeriksa riwayat pembayaran atau saldo penghasilan toko.',
      route: '',
      onTap: () {
        logger.i('Menu Payments diklik!');
      },
    ),
  ];
}