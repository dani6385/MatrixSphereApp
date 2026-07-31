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
      // Ganti Row dengan satu PopupMenuButton
      leading: PopupMenuButton<String>(
        icon: const Icon(Icons.menu), // Ikon utama untuk membuka dropdown
        onSelected: (String value) {
          // Logika ketika sebuah item menu dipilih
          switch (value) {
            case 'open_drawer':
              // Membuka drawer (menu kiri)
              HomeScreen.scaffoldKey.currentState?.openDrawer();
              break;
            case 'search':
              // Navigasi ke halaman pencarian
              // context.push(AppRoutes.search);
              break;
            case 'settings':
              // Navigasi ke halaman pengaturan
              context.push(AppRoutes.settings);
              break;
            case 'edit':
              // Navigasi ke halaman edit
              // context.push(AppRoutes.editDashboard);
              break;
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          const PopupMenuItem<String>(
            value: 'open_drawer',
            child: Text('Buka Menu Navigasi'),
          ),
          const PopupMenuItem<String>(
              value: 'search', child: Text('Pencarian')),
          const PopupMenuItem<String>(
              value: 'settings', child: Text('Pengaturan')),
          const PopupMenuItem<String>(
              value: 'edit', child: Text('Edit Dasbor')),
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
