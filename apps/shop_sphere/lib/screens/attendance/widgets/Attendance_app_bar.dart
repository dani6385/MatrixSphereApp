import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:shop_sphere/navigation/app_routes.dart';


import '../attendance_screen.dart'; // 1. PASTIKAN IMPORT AttendanceSCREEN

class AttendanceAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AttendanceAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Attendance'),

      // 2. KODE LEADING MENJADI LEBIH SIMPEL & DIJAMIN AKTIF
      leading: IconButton(
        icon: const Icon(Icons.account_circle),
        onPressed: () {
          // Membuka laci secara paksa menggunakan GlobalKey milik AttendanceScreen
          AttendanceScreen.scaffoldKey.currentState?.openDrawer();
        },
      ),

      actions: [
        // --- AWAL PERUBAHAN ---
        // Menggunakan IconButton untuk navigasi langsung ke halaman chat
        Builder(          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                context.goNamed(AppRoutes.account);
              },
            );
          },
        ),
        // --- AKHIR PERUBAHAN ---

        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Handle notification icon press
          },
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Membuka laci secara paksa menggunakan GlobalKey milik AttendanceScreen
            AttendanceScreen.scaffoldKey.currentState?.openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
