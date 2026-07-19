// lib/screens/home/widgets/home_app_bar.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere/routes/app_routes.dart';
import 'package:provider/provider.dart';
import '../../chat/providers/chat_provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});
// lib/screens/home/widgets/home_app_bar.dart

@override
Widget build(BuildContext context) {
  return AppBar(
    title: const Text('Home'),
    
    // 1. PINDAHKAN KE SINI (leading) agar muncul di sebelah kiri:
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.account_circle),
        onPressed: () {
          // DISARANKAN: ganti openEndDrawer() menjadi openDrawer() 
          // agar menu terbuka dari sisi kiri sesuai posisi tombolnya
          Scaffold.of(context).openDrawer(); 
        },
      ),
    ),

    // Parameter actions di bawah hanya menyisakan menu chat (di sebelah kanan)
    actions: [
      Builder(
        builder: (context) {
          final chatProvider = context.watch<ChatProvider>();
          final messages = chatProvider.unreadMessagesList;

          return IconButton(
            icon: Badge(
              label: Text('${messages.length}'),
              isLabelVisible: messages.isNotEmpty,
              child: const Icon(Icons.chat),
            ),
            onPressed: () {
              GoRouter.of(context).push(AppRoutes.chat);
            },
          );
        },
      ),
    ],
  );
}  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
