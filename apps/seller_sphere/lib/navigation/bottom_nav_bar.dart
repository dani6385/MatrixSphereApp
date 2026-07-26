import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:seller_sphere/navigation/app_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_ui/shared_ui.dart';

/// A wrapper widget that configures and displays the [SharedBottomNavBar]
/// with tabs specific to the Seller Sphere application.
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    // Data untuk ikon, dipetakan berdasarkan rute
    const Map<String, ({IconData icon, IconData activeIcon})> tabIcons = {
      AppRoutes.home: (
        icon: Icons.home_outlined,
        activeIcon: Icons.home
        ),
      AppRoutes.stream: (
        icon: Icons.cast,
        activeIcon: Icons.cast_connected
        ),
      AppRoutes.inventory: (
        icon: Icons.point_of_sale,
        activeIcon: Icons.point_of_sale_outlined
      ),
      AppRoutes.sellers: (
        icon: Icons.inventory_2,
        activeIcon: Icons.inventory_2_outlined
      ),
      AppRoutes.attendance: (
        icon: Icons.fingerprint_outlined,
        activeIcon: Icons.fingerprint
      ),
    };

    // Menggunakan widget SharedBottomNavBar dari paket shared_ui
    return SharedBottomNavBar(
      currentIndex: currentIndex,
      onTap: onTap,
      // Membuat daftar GButton secara dinamis berdasarkan rute aplikasi
      tabs: List.generate(appShellBranches.length, (index) {
        final isSelected = index == currentIndex;
        final routePath = (appShellBranches[index].routes.first as dynamic).path;
        final icons = tabIcons[routePath]!;
        return GButton(
          icon: isSelected ? icons.activeIcon : icons.icon,
          text: '', // Teks dikosongkan sesuai desain
          iconSize: 26,
        );
      }),
    );
  }
}
