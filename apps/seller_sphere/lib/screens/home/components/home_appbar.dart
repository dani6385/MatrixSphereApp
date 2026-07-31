
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/screens/home/home_screen.dart';
import 'package:seller_sphere/navigation/app_routes.dart';

//import 'package:shared_ui/shared_ui.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 100, // 1. Beri ruang lebih untuk dua tombol
      leading: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu), // Tombol menu kiri yang sudah ada
            onPressed: () {
              // Membuka drawer (menu kiri)
              HomeScreen.scaffoldKey.currentState?.openDrawer();
            },
          ),
          // 2. Tambahkan IconButton baru di sini
          IconButton(
            icon: const Icon(Icons.search), // Contoh: Ikon pencarian
            onPressed: () {
              // Tambahkan aksi untuk tombol ini, misalnya navigasi ke halaman pencarian
              // context.push(AppRoutes.search);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings), // Contoh: Ikon pencarian
            onPressed: () {
              // Tambahkan aksi untuk tombol ini, misalnya navigasi ke halaman pencarian
              // context.push(AppRoutes.search);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit), // Contoh: Ikon pencarian
            onPressed: () {
              // Tambahkan aksi untuk tombol ini, misalnya navigasi ke halaman pencarian
              // context.push(AppRoutes.search);
            },
          ),
        ],
      ),
      title: const Text('Dasbor Penjual'),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined, size: 28),
          onPressed: () => context.push(AppRoutes.notifications),
        ),
        // --- AWAL PERUBAHAN: Menambahkan Dropdown Menu ---
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert), // Ikon titik tiga vertikal
          onSelected: (String value) {
            // Logika ketika sebuah item menu dipilih
            switch (value) {
              case 'kalkulator':
                // Membuka laci kanan (endDrawer) untuk kalkulator
                HomeScreen.scaffoldKey.currentState?.openEndDrawer();
                break;
              case 'pengaturan':
                // Contoh: Navigasi ke halaman pengaturan
                // context.push('/settings');
                break;
              case 'account':
                // Navigasi ke halaman akun pengguna
                // context.push(AppRoutes.account);
                break;
              case 'logout':
                // Tambahkan logika untuk logout pengguna
                // Contoh: context.read<AuthBloc>().add(AuthLogoutRequested());
                break;
              // Tambahkan case lain untuk item menu lainnya
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'kalkulator',
              child: Text('Buka Kalkulator'),
            ),
            const PopupMenuItem<String>(
              value: 'pengaturan',
              child: Text('Pengaturan'),
            ),
            const PopupMenuDivider(), // Garis pemisah
            const PopupMenuItem<String>(
              value: 'account',
              child: Text('Akun Saya'),
            ),
            const PopupMenuItem<String>(
              value: 'logout',
              child: Text('Logout'),
            ),
          ],
        ),
        // --- AKHIR PERUBAHAN ---
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}