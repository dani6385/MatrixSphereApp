// lib/features/Report/presentation/widgets/Report_app_bar.dart

import 'package:flutter/material.dart';

class ReportAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ReportAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      // Latar belakang transparan agar gradient dari body terlihat.
      backgroundColor: Colors.transparent,
      elevation: 0,

      // Tombol di sebelah kiri untuk membuka Drawer utama (navigasi laporan)
      leading: IconButton(
        icon: Icon(
          Icons.analytics, // Ikon analitik/grafik khusus halaman Report
          color: colorScheme.onSurface,
        ),
        tooltip: 'Buka Menu Navigasi',
        onPressed: () {
          // Membuka Drawer dari sisi kiri
          Scaffold.of(context).openDrawer();
        },
      ),

      // Judul AppBar disesuaikan menjadi Laporan Penjualan.
      title: Text(
        'Laporan Penjualan',
        style: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,

      // Tombol di sebelah kanan (actions) untuk membuka EndDrawer (filter/tanggal laporan)
      actions: [
        IconButton(
          icon: Icon(
            Icons.filter_list, // Ikon filter untuk menyaring data laporan
            color: colorScheme.onSurface,
          ),
          tooltip: 'Buka Filter Laporan',
          onPressed: () {
            // Membuka EndDrawer dari sisi kanan
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}