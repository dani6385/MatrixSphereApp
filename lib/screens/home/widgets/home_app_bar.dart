import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere/routes/app_routes.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Home'),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'chat') {
              // Perintah untuk pergi ke halaman chat
              GoRouter.of(context).push(AppRoutes.chat);
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'chat',
              child: Text('Pesan'),
            ),
            // Anda bisa menambahkan item dropdown lain di sini
          ],
          icon: const Icon(Icons.more_vert), // Ikon titik tiga
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
