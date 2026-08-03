import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';

import 'package:shared_ui/shared_ui.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class HomeEndDrawer extends StatelessWidget {
  const HomeEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: header,
      items: items(context), // Pass context to the items method
      selectedRoute: selectedRoute(context), // Perbaikan: Panggil metode selectedRoute dengan context
      footer: const Text('Pengaturan v1.0.0'),
    );
  }

  Widget get header => const DrawerHeader(
        decoration: BoxDecoration(color: kDarkAppBar),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.settings, color: kBrandPrimary, size: 48),
            SizedBox(height: AppSpacing.sm),
            Text(
              'Pengaturan',
              style: TextStyle(
                color: kDarkTextPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  // Perbaikan: selectedRoute sekarang adalah metode yang mengambil BuildContext
  String selectedRoute(BuildContext context) {
    final GoRouter router = GoRouter.of(context);
    return router.location;
  }

  List<SideMenuItem> items(BuildContext context) => [
        // Make items a method that accepts BuildContext
        SideMenuItem(
          title: 'Profil',
          icon: Icons.person_outline,
          onTap: () {
            _logger.i('Profil tapped');
            Navigator.of(context).pop();
            context.go(AppRoutes.profile);
          },
          route: AppRoutes.profile, // Perbaikan: Gunakan konstanta dari AppRoutes
        ),
        // TODO: Aktifkan kembali setelah rute '/notifications' dibuat di app_router.dart dan AppRoutes
        // SideMenuItem(
        //   title: 'Notifikasi',
        //   icon: Icons.notifications_outlined,
        //   onTap: () {
        //     _logger.i('Notifikasi tapped');
        //     Navigator.of(context).pop();
        //     // context.go(AppRoutes.notifications); // Ganti jika sudah ada
        //   },
        //   route: '/notifications', // Ganti dengan AppRoutes.notifications jika sudah dibuat
        // ),
        // TODO: Aktifkan kembali setelah rute '/help' dibuat di app_router.dart dan AppRoutes
        // SideMenuItem(
        //   title: 'Bantuan & Dukungan',
        //   icon: Icons.help_outline,
        //   onTap: () {
        //     _logger.i('Bantuan & Dukungan tapped');
        //     Navigator.of(context).pop();
        //     // context.go(AppRoutes.help); // Ganti jika sudah ada
        //   },
        //   route: '/help', // Ganti dengan AppRoutes.help jika sudah dibuat
        // ),
        SideMenuItem(
          title: 'Keluar',
          icon: Icons.logout,
          onTap: () {
            _logger.i('Keluar tapped');
            Navigator.of(context).pop();
            // Implementasi logika logout
            FirebaseAuth.instance.signOut().then((_) {});
          },
          route: AppRoutes.login, // Rute ini akan menjadi aktif setelah logout
        ),
      ];
}
