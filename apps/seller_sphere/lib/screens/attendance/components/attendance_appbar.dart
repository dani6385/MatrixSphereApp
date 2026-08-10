// lib/features/attendance/presentation/widgets/attendance_app_bar.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AttendanceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    

    return AppBar(
      // Latar belakang transparan agar gradient dari body terlihat.
      backgroundColor: Colors.transparent,
      elevation: 0,

      // Tombol di sebelah kiri untuk membuka Drawer utama (navigasi presensi)
      leading: IconButton(
        icon: Icon(
          Icons.fingerprint, // Ikon sidik jari khusus halaman attendance
          color: context.onSurface,
        ),
        tooltip: 'Buka Menu Navigasi',
        onPressed: () {
          // Membuka Drawer dari sisi kiri
          Scaffold.of(context).openDrawer();
        },
      ),

      // Judul AppBar.
      title: Text(
        'Presensi Kehadiran',
        style: TextStyle(
          color: context.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,

      // Tombol di sebelah kanan (actions) untuk membuka EndDrawer (kalender/riwayat)
      actions: [
        IconButton(
          icon: Icon(
            Icons.calendar_today, // Ikon kalender untuk riwayat/jadwal kerja
            color: context.onSurface,
          ),
          tooltip: 'Buka Kalender & Riwayat',
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