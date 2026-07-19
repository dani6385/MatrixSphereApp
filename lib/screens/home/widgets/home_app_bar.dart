// lib/screens/home/widgets/home_app_bar.dart

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
            // Mengambil data jumlah pesan dari ChatProvider
            final unreadMessages = context.watch<ChatProvider>().unreadCount;

            return IconButton(
              icon: Badge(
                label: Text('$unreadMessages'), 
                isLabelVisible: unreadMessages > 0, 
                child: const Icon(Icons.chat),
              ),
              onPressed: () { // Indentasi dirapikan di sini
                GoRouter.of(context).push(AppRoutes.chat);
              },
            );
          }, // Indentasi dirapikan di sini
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