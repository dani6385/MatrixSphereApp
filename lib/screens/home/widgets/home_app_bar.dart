import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere/routes/app_routes.dart';
import 'package:provider/provider.dart';
import '../../chat/providers/chat_provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Home'),
      actions: [
        Builder(
          builder: (context) {
            // 1. Ambil data jumlah pesan dari Provider Anda (contoh nama: ChatProvider)
            // Silakan sesuaikan dengan provider chat asli Anda jika ada
            final unreadMessages = context.watch<ChatProvider>().unreadCount;

            return IconButton(
              icon: Badge(
                label: Text('$unreadMessages'), // Menampilkan angka dinamis
                isLabelVisible: unreadMessages > 0, // Hanya muncul jika ada pesan > 0
                child: const Icon(Icons.chat),
              ),
            onPressed: () {
              GoRouter.of(context).push(AppRoutes.chat);
            },
          );
          }
        ),
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
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

