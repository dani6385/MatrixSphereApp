import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/config/bottom_nav_config.dart';
import 'package:shared_ui/src/widgets/custom_bottom_nav_bar.dart';

/// Scaffold yang membungkus konten utama aplikasi dan menampilkan
/// CustomBottomNavBar.
class ScaffoldWithNavBar extends ConsumerWidget {
  /// Widget konten yang akan ditampilkan di atas bilah navigasi.
  /// Ini biasanya adalah GoRouter's ShellRoute.
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dapatkan konfigurasi item navigasi dari provider
    final navConfig = ref.watch(bottomNavConfigProvider);

    // Tentukan lokasi saat ini untuk mengetahui tab mana yang aktif
    final GoRouterState state = GoRouterState.of(context);
    final String location = state.uri.toString();

    // Tentukan currentIndex berdasarkan lokasi saat ini
    final int currentIndex = _locationToTabIndex(location, navConfig.items);

    return Scaffold(
      body: child,
      bottomNavigationBar: CustomBottomNavBar(
        items: navConfig.items,
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(index, context, navConfig.items),
      ),
    );
  }

  /// Menentukan indeks tab berdasarkan path rute saat ini.
  int _locationToTabIndex(String location, List<dynamic> items) {
    final index = items.indexWhere((item) => location.startsWith(item.routePath));
    // Jika tidak ada yang cocok, kembalikan 0 (tab pertama)
    return index < 0 ? 0 : index;
  }

  /// Navigasi ke rute yang sesuai saat item tab ditekan.
  void _onItemTapped(int index, BuildContext context, List<dynamic> items) {
    if (index < 0 || index >= items.length) return;

    final String routePath = items[index].routePath;
    GoRouter.of(context).go(routePath);
  }
}
