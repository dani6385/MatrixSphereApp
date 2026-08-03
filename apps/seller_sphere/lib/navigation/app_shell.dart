import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'app_extractor.dart';
import 'bottom_nav_bar.dart'; // <-- 1. Impor widget BottomNavBar yang baru
import 'package:shared_ui/shared_ui.dart';

/// Widget "cangkang" utama aplikasi yang berisi Scaffold, BottomNavBar,
/// dan Drawer. Widget ini membungkus semua halaman yang ada di dalam tab.
class AppShell extends StatelessWidget {
  /// Widget dari go_router yang menampilkan halaman aktif.
  final StatefulNavigationShell navigationShell;

  const AppShell({
    super.key,
    required this.navigationShell,
  });

  // Fungsi untuk berpindah tab
  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      // Jika kita menekan tab yang sudah aktif, kembali ke halaman awal tab tersebut.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan rute saat ini untuk menentukan AppBar mana yang akan ditampilkan
    final String location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      // AppBar bisa dibuat dinamis berdasarkan tab yang aktif jika diperlukan
      appBar: _buildAppBar(location),
      // Drawer dan EndDrawer sekarang dinamis berdasarkan tab yang aktif
      drawer: _buildDrawer(),
      endDrawer: _buildEndDrawer(),
      // Konten utama yang akan berganti sesuai tab
      body: navigationShell,
      // 2. Ganti implementasi lama dengan widget BottomNavBar yang baru
      bottomNavigationBar: BottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }

  /// Helper function untuk membangun AppBar yang sesuai.
  /// Saat ini hanya mengembalikan AppBar default.
  /// Ini bisa dikembangkan untuk menampilkan AppBar yang berbeda per tab.
  PreferredSizeWidget? _buildAppBar(String location) {
    // Contoh: jika di halaman home, jangan tampilkan AppBar dari shell
    // karena HomeScreen sudah punya AppBar sendiri.
    if (location == AppRoutes.home) {
      return null;
    }
    // Untuk halaman lain, tampilkan AppBar default.
    return AppBar(
      title: const Text('Seller Sphere'),
      backgroundColor: kDarkAppBar,
    );
  }

  /// Helper function untuk membangun Drawer yang sesuai dengan tab aktif.
  Widget? _buildDrawer() {
    // Gunakan switch pada index tab saat ini
    switch (navigationShell.currentIndex) {
      case 0: // Index 0 adalah tab 'Home'
        return const HomeDrawer();
      case 4: // Index 4 adalah tab 'Attendance'
        return const AttendanceDrawer();
      default:
        // Untuk tab lain, tidak ada drawer.
        return null;
    }
  }

  /// Helper function untuk membangun EndDrawer yang sesuai dengan tab aktif.
  Widget? _buildEndDrawer() {
    // Gunakan switch pada index tab saat ini
    switch (navigationShell.currentIndex) {
      case 0: // Index 0 adalah tab 'Home'
        return const HomeEndDrawer();
      // Jika ada tab lain yang butuh endDrawer, tambahkan di sini.
      // case 1:
      //   return const StreamEndDrawer();
      default:
        // Untuk tab lain, tidak ada endDrawer.
        return null;
    }
  }
}
