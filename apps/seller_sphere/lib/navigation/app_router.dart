import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_extraktor.dart';
import 'package:shared_services/shared_services.dart';
import 'app_routes.dart';
import 'bottom_nav_bar.dart';

// 1. Definisikan GlobalKey untuk navigator
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// 2. Definisikan cabang-cabang untuk StatefulShellRoute
final List<StatefulShellBranch> appShellBranches = [
  // Branch 1: Home
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.home, // Path: '/'
        builder: (context, state) => const HomeScreen()),
  ]),
  // Branch 2: Stream
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.stream, // Path: '/stream'
        builder: (context, state) =>
            const StreamingScreen(streamId: 'default_stream')),
  ]),
  // Branch 3: Management
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.management, // Path: '/management'
        builder: (context, state) => const ManagementScreen()),
  ]),
  // Branch 4: Sellers (Inventory)
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.sellers, // Path: '/sellers'
        builder: (context, state) => const SellerScreen()),
  ]),
  // Branch 5: Attendance
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.attendance, // Path: '/attendance'
        builder: (context, state) => const AttendanceScreen()),
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
        return PopScope(
          // Allow popping only when on the home tab (index 0)
          canPop: navigationShell.currentIndex == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (navigationShell.currentIndex != 0) {
              navigationShell.goBranch(0);
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

    // PERBAIKAN FINAL: Rute produk sebagai rute fullscreen dengan path '/products'
    GoRoute(
      path: AppRoutes.products, // Path: '/products'
      builder: (context, state) {
        final Product? product = state.extra as Product?;
        if (product != null) {
          return ProductScreen(product: product, shopUid: '',);
        } else {
          return const Scaffold(
            body:
                Center(child: Text('Produk tidak ditemukan atau tidak valid.')),
          );
        }
      },
      routes: [
        GoRoute(
          path: ':productId',
          builder: (context, state) => const ProductListScreen(shopUid: ''),
        ),
      ],
    ),
  ],
  // Halaman error jika rute tidak ditemukan
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error?.message}'),
    ),
  ),
);

/// Widget terpisah untuk Scaffold yang berisi BottomNavBar.
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