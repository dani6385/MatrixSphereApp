import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/routes/app_routes.dart';
import 'package:provider/provider.dart';
import '../../../chat/providers/chat_provider.dart';
import '../home_screen.dart'; // 1. PASTIKAN IMPORT HOMESCREEN

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Home'),

      // 2. KODE LEADING MENJADI LEBIH SIMPEL & DIJAMIN AKTIF
      leading: IconButton(
        icon: const Icon(Icons.account_circle),
        onPressed: () {
          // Membuka laci secara paksa menggunakan GlobalKey milik HomeScreen
          HomeScreen.scaffoldKey.currentState?.openDrawer();
        },
      ),

      actions: [
        // --- AWAL PERUBAHAN ---
        // Menggunakan IconButton untuk navigasi langsung ke halaman chat
        Builder(
          builder: (context) {
            // Dapatkan provider dan daftar pesan yang belum dibaca
            final chatProvider = context.watch<ChatProvider>();
            // Asumsi unreadMessagesList adalah List<String> atau bisa di-length
            final messages = chatProvider.unreadMessagesList;

            return IconButton(
              icon: Badge(
                label: Text('${messages.length}'),
                isLabelVisible: messages.isNotEmpty,
                child: const Icon(Icons.chat),
              ),
              onPressed: () {
                // Navigasi ke halaman chat saat ikon ditekan
                GoRouter.of(context).push(AppRoutes.chat);
              },
            );
          },
        ),
        // --- AKHIR PERUBAHAN ---
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(
                Icons.settings), // Menggunakan ikon roda gigi (pengaturan)
            onPressed: () {
              // Membuka laci samping sebelah kanan (endDrawer)
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
