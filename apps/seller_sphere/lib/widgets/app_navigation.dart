import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart'; // Impor komponen dari shared_ui

class AppNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigation({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      // Panggil komponen dari shared_ui di sini
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
            label: 'Produk', // Diubah dari 'Status'
            icon: Icons.inventory_2_outlined, // Diubah dari 'wifi'
            activeIcon: Icons.inventory_2,
            branchIndex: 1,
          ),
          AppTabItem(
            label: 'Pesanan', // Diubah dari 'Transaksi'
            icon: Icons.receipt_long_outlined,
            activeIcon: Icons.receipt_long_rounded,
            branchIndex: 2,
          ),
          AppTabItem(
            label: 'Akun',
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            branchIndex: 3,
          ),
        ],
      ),
    );
  }
}