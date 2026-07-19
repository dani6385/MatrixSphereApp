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

            // GANTI "return IconButton(...)" Anda dengan kode ini:
            return PopupMenuButton<String>(
              // 1. Tampilan pemicu dropdown (menggunakan Badge + Ikon Chat)
              icon: Badge(
                label: Text('${messages.length}'),
                isLabelVisible: messages.isNotEmpty,
                child: const Icon(Icons.chat),
              ),

              // 2. Aksi saat salah satu item dropdown dipilih/diklik
              onSelected: (value) {
                if (value == 'see_all') {
                  GoRouter.of(context)
                      .push(AppRoutes.chat); // Navigasi ke halaman chat penuh
                } else {
                  debugPrint("Membuka detail pesan: $value");
                  GoRouter.of(context).push(AppRoutes.chat);
                }
              },

              // 3. Konten isi dropdown
              itemBuilder: (BuildContext context) {
                if (messages.isEmpty) {
                  return [
                    const PopupMenuItem<String>(
                      enabled: false, // Tidak bisa diklik
                      child: Text(
                        'Tidak ada pesan baru',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ];
                }

                // Mengubah daftar pesan menjadi item menu dropdown
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

                // Tambahkan pembatas dan tombol "Lihat Semua" di bagian bawah dropdown
                items.addAll([
                  const PopupMenuDivider(),
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
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
