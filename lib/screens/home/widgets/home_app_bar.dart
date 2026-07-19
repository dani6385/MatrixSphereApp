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
            final chatProvider = context.watch<ChatProvider>();
            final messages = chatProvider.unreadMessagesList;
            //final unreadCount = chatProvider.unreadCount;

            return PopupMenuButton<String>(
              icon: Badge(
                label: Text('$unreadMessages'),
                isLabelVisible: unreadMessages > 0,
                child: const Icon(Icons.chat),
              ),
              onSelected: (value) {
                if (value == 'see_all') {
                  // Navigasi ke halaman chat jika memilih "Lihat Semua Pesan"
                  GoRouter.of(context).push(AppRoutes.chat);
                } else {
                  // Menangani klik pada pesan spesifik (bisa diarahkan ke detail chat)
                  debugPrint("Membuka detail pesan: $value");
                  GoRouter.of(context).push(AppRoutes.chat);
                }
              },
              itemBuilder: (BuildContext context) {
                // Jika tidak ada pesan baru
                if (messages.isEmpty) {
                  return [
                    const PopupMenuItem<String>(
                      enabled: false, // Tidak bisa diklik
                      child: Text(
                        'Tidak ada pesan baru',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ]; // Tambahkan return di sini
                }
                final List<PopupMenuEntry<String>> items =
                    messages.map((message) {
                  return PopupMenuItem<String>(
                    value: message,
                    child: Text(
                      message,
                      maxLines: 1,
                      overflow: TextOverflow
                          .ellipsis, // Potong teks jika terlalu panjang
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList();

                // Tambahkan garis pembatas dan tombol "Lihat Semua Pesan" di bagian bawah dropdown
                items.addAll([
                  const PopupMenuDivider(), // Garis pembatas tipis
                  const PopupMenuItem<String>(
                    value: 'see_all',
                    child: Center(
                      child: Text(
                        'Lihat Semua Pesan',
                        style: TextStyle(
                          color: Colors.blue,
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
