// lib/features/home/presentation/widgets/home_app_bar.dart

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:seller_sphere/navigations/app_extractor.dart';

import 'package:shared_ui/shared_ui.dart';

final logger = Logger();

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    return AppBar(
      // Latar belakang transparan agar gradient dari body terlihat.[cite: 10]
      backgroundColor: kTransparent,
      elevation: 0,

      // Tombol ikon di sebelah kiri untuk membuka Drawer utama
      leading: IconButton(
        icon: Icon(
          Icons.person_outline, // Ikon garis tiga standar untuk Drawer
          color: context.onSurface,
        ),
        onPressed: () {
          // Perintah untuk membuka Drawer dari sisi kiri
          Scaffold.of(context).openDrawer();
        },
      ),

      // Judul AppBar.[cite: 10]
      title: Text(
        'Home',
        style: TextStyle(
          color: context.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,

      // Tombol di sebelah kanan (actions) untuk membuka EndDrawer (profil/pengaturan).
      actions: [
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: context.onSurface,
          ),
          onPressed: () {
            logger.i('Ikon Pesan diklik!');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigasi ke halaman Bahasa.')),
            );
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                  builder: (context) => const NotificationScreen()),
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.message_outlined,
            color: context.onSurface,
          ),
          onPressed: () {
            logger.i('Ikon Pesan diklik!');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigasi ke halaman Bahasa.')),
            );
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.bar_chart_outlined,
            color: context.onSurface,
          ),
          onPressed: () {
            logger
                .i('Ikon Chart diklik! Navigasi ke Halaman Manajemen (Kasir).');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Membuka halaman kasir...')),
            );
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (context) => const ManagementScreen()),
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.settings, // Ikon profil atau akun untuk EndDrawer
            color: context.onSurface,
          ),
          onPressed: () {
            // Perintah untuk membuka EndDrawer dari sisi kanan
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
