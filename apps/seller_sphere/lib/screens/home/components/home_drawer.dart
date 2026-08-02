import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';

import 'package:shared_ui/shared_ui.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SideMenu(
      header: header,
      items: items(context), // Pass context to the items method
      selectedRoute: selectedRoute,
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
              'Pintasan',
              style: TextStyle(
                color: kDarkTextPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  List<SideMenuItem> items(BuildContext context) => [
        // Make items a method that accepts BuildContext
        SideMenuItem(
          title: 'Profil',
          icon: Icons.person_outline,
          isSelected: false,
          onTap: () {
            _logger.i('Profil tapped');
            Navigator.of(context).pop();
            context.go(AppRoutes.profile);
          },
          route: '/profile',
        ),
        SideMenuItem(
          title: 'Notifikasi',
          icon: Icons.notifications_outlined,
          isSelected: false,
          onTap: () {
            _logger.i('Notifikasi tapped');
            Navigator.of(context).pop();
            // Implement navigation to notifications page
          },
          route: '/notifications',
        ),
        SideMenuItem(
          title: 'Bantuan & Dukungan',
          icon: Icons.help_outline,
          isSelected: false,
          onTap: () {
            _logger.i('Bantuan & Dukungan tapped');
            Navigator.of(context).pop();
            // Implement navigation to help and support page
          },
          route: '/help',
        ),
        SideMenuItem(
          title: 'Keluar',
          icon: Icons.logout,
          isSelected: false,
          onTap: () {
            _logger.i('Keluar tapped');
            Navigator.of(context).pop();
            // Implement logout logic
          },
          route: '/logout',
        ),
      ];

  String get selectedRoute => '';
}
