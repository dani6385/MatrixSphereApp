import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

class AppNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigation({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        navigationShell: navigationShell,
        tabs: const [
          AppTabItem(
            label: 'Home',
            icon: Icons.home_outlined,
            activeIcon: Icons.home_rounded,
            branchIndex: 0,
          ),
          AppTabItem(
            label: 'Persetujuan', // Diubah dari 'Mitra'
            icon: Icons.how_to_reg_outlined, // Ikon baru
            activeIcon: Icons.how_to_reg, // Ikon aktif baru
            branchIndex: 1, // Indeks disesuaikan
          ),
          AppTabItem(
            label: 'Prestasi',
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            branchIndex: 2, // Indeks disesuaikan
          ),
          AppTabItem(
            label: 'Settings', // Diubah dari 'Mitra'
            icon: Icons.how_to_reg_outlined, // Ikon baru
            activeIcon: Icons.how_to_reg, // Ikon aktif baru
            branchIndex: 1, // Indeks disesuaikan
          ),
          AppTabItem(
            label: 'Akun',
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            branchIndex: 2, // Indeks disesuaikan
          ),
          AppTabItem(
            label: 'Settings',
            icon: Icons.settings_outlined,
            activeIcon: Icons.settings_rounded,
            branchIndex: null, // Ini tidak akan menjadi tab navigasi aktif
          ),
        ],
      ),
    );
  }
}
