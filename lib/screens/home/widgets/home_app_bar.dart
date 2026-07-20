// lib/screens/home/widgets/home_app_bar.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
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
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            Scaffold.of(context).openEndDrawer(); // Membuka menu samping kanan
          },
        ),
      ),
      actions: [
        Builder(
          builder: (context) {
            final chatProvider = context.watch<ChatProvider>();
            final messages = chatProvider.unreadMessagesList;

            // MENGGUNAKAN POPUMENUBUTTON UNTUK DROPDOWN YANG BISA DIKLIK
            return PopupMenuButton<String>(
              icon: Badge(
                label: Text('${messages.length}'),
                isLabelVisible: messages.isNotEmpty,
                child: const Icon(Icons.chat),
              ),
              onSelected: (value) {
                if (value == 'see_all') {
                  GoRouter.of(context).push(AppRoutes.chat);
                } else {
                  GoRouter.of(context).push(AppRoutes.chat);
                }
              },
              itemBuilder: (BuildContext context) {
                if (messages.isEmpty) {
                  return [
                    const PopupMenuItem<String>(
                      enabled: false,
                      child: Text(
                        'Tidak ada pesan baru',
                        style: TextStyle(color: kDarkTextSecondary),
                      ),
                    )
                  ];
                }

                final List<PopupMenuEntry<String>> items = messages.map((message) {
                  return PopupMenuItem<String>(
                    value: message,
                    child: Text(
                      message,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList();

                items.addAll([
                  const PopupMenuDivider(),
                  const PopupMenuItem<String>(
                    value: 'see_all',
                    child: Center(
                      child: Text(
                        'Lihat Semua Pesan',
                        style: TextStyle(
                          color: kBlueSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ]);
                return items;
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}