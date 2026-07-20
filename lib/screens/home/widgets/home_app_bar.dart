import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:matrix_sphere/routes/app_routes.dart';
import 'package:provider/provider.dart';
import '../../chat/providers/chat_provider.dart';
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
        Builder(
          builder: (context) {
            final chatProvider = context.watch<ChatProvider>();
            final messages = chatProvider.unreadMessagesList;

            return PopupMenuButton<String>(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Badge(
                  label: Text('${messages.length}'),
                  isLabelVisible: messages.isNotEmpty,
                  child: const Icon(Icons.chat),
                ),
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
                final List<PopupMenuEntry<String>> items =
                    messages.map((message) {
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
