import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_extraktor.dart';
import 'package:seller_sphere/navigation/bottom_nav_bar.dart';
import 'package:shared_services/shared_services.dart';

import 'app_routes.dart';

// 1. Definisikan GlobalKey untuk navigator
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// 2. Definisikan cabang-cabang untuk StatefulShellRoute
final List<StatefulShellBranch> appShellBranches = [
  // Branch 1: Home
  StatefulShellBranch(routes: [
    GoRoute(
        path: '/',
        builder: (context, state) =>
            const HomeScreen()),
  ]),
  // Branch 2: Stream
  StatefulShellBranch(routes: [
    GoRoute(
        path: '/stream',
        builder: (context, state) =>
            const StreamingScreen(streamId: 'default_stream')),
  ]),
  // Branch 3: Management
  StatefulShellBranch(routes: [
    GoRoute(
        path: '/management',
        builder: (context, state) => const ManagementScreen(),
        // Daftarkan rute untuk produk sebagai sub-rute dari /management
        routes: [
          GoRoute(
            path: 'products', // Path menjadi: /management/products
            builder: (context, state) => const ProductListScreen(shopUid: 'default_shop'), // Ganti dengan UID toko yang sesuai
            routes: [
              GoRoute(
                path: ':productId', // Path menjadi: /management/products/:productId
                builder: (context, state) => ProductScreen(product: state.extra as Product),
              ),
            ],
          ),
        ]),
  ]),
  // Branch 4: Sellers (Inventory)
  StatefulShellBranch(routes: [
    GoRoute(
        path: '/sellers',
        builder: (context, state) =>
            const SellerScreen()),
  ]),
  // Branch 5: Attendance
  StatefulShellBranch(routes: [
    GoRoute(
        path: '/attendance',
        builder: (context, state) =>
            const AttendanceScreen()),
  ]),
];

// Buat instance GoRouter
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home, // Lokasi awal aplikasi
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    // 3. Gunakan StatefulShellRoute untuk halaman dengan BottomNavBar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // PopScope digunakan untuk mengintersep aksi tombol kembali dari sistem.
        return PopScope(
          // canPop: false berarti kita akan menangani logika pop secara manual.
          canPop: false,
          // onPopInvoked akan dipanggil saat tombol kembali ditekan.
          // ignore: deprecated_member_use
          onPopInvoked: (didPop) {
            // Jika pop tidak terjadi (karena canPop: false), jalankan logika kita.
            if (!didPop) {
              // Jika kita tidak sedang di halaman utama (indeks 0), kembali ke halaman utama.
              if (navigationShell.currentIndex != 0) {
                navigationShell.goBranch(0);
              }
              // Jika kita sudah di halaman utama, tidak melakukan apa-apa,
              // sehingga back button berikutnya (jika ditekan lagi) akan keluar dari app.
              // Perilaku ini dikelola oleh sistem operasi.
            }
          },
          child: ScaffoldWithNavBar(navigationShell: navigationShell),
        );
      },
      branches: appShellBranches,
    ),

    // 4. Rute fullscreen (tanpa BottomNavBar)
    GoRoute(
        path: AppRoutes.chat, builder: (context, state) => const ChatScreen()),
  ],
  // Halaman error jika rute tidak ditemukan
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
);

/// Widget terpisah untuk Scaffold yang berisi BottomNavBar.
/// Ini membantu menjaga kerapian kode di dalam builder StatefulShellRoute.
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
      ),
    );
  }
}
