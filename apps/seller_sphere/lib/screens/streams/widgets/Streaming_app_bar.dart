import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:seller_sphere/navigation/app_routes.dart';


import '../streaming_screen.dart'; // 1. PASTIKAN IMPORT StreamingSCREEN

class StreamingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StreamingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Streaming'),

      // 2. KODE LEADING MENJADI LEBIH SIMPEL & DIJAMIN AKTIF
      leading: IconButton(
        icon: const Icon(Icons.account_circle),
        onPressed: () {
          // Membuka laci secara paksa menggunakan GlobalKey milik StreamingScreen
          StreamingScreen.scaffoldKey.currentState?.openDrawer();
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
            // Membuka laci secara paksa menggunakan GlobalKey milik StreamingScreen
            StreamingScreen.scaffoldKey.currentState?.openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
