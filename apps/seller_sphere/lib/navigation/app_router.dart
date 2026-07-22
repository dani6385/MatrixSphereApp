// app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/models/product.dart';
import 'package:seller_sphere/navigation/app_navigator.dart';
import 'package:seller_sphere/screens/attendance/attendance_screen.dart';
import 'package:seller_sphere/screens/home/home_screen.dart';
import 'package:seller_sphere/screens/inventory/inventory_screen.dart';
import 'package:seller_sphere/screens/sellers/seller_screen.dart';
import 'package:seller_sphere/screens/streams/streaming_screen.dart';

import 'app_routes.dart';

// Kunci GlobalKey untuk NavigatorShell, diperlukan untuk StatefulShellRoute
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// Placeholder screen untuk fitur yang belum dibuat
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Layar untuk $title')),
    );
  }
}

/// The main router configuration for the application.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home, // Lokasi awal aplikasi
  debugLogDiagnostics: true, // Set to false in production
  routes: [
    // Konfigurasi untuk navigasi utama dengan BottomNavigationBar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Widget AppNavigator akan membungkus dan menampilkan layar dari cabang (branch)
        return AppNavigator(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        // Setiap branch mewakili satu item di BottomNavigationBar
        // Branch 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home, // path: '/'
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Branch 1: Stream
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.stream, // path: '/stream'
              builder: (context, state) => const StreamingScreen(),
            ),
          ],
        ),
        // Branch 2: Kasir (POS) - Rute ini belum ada di AppRoutes, kita buat placeholder
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.sellers, // path: '/sellers'
              builder: (context, state) => const SellerScreen(),
            ),
          ],
        ),
        // Branch 3: Inventory
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.inventory, // path: '/inventory'
              builder: (context, state) => InventoryScreen(onNavigateToLabelPrinter: (Product p1) {}),
            ),
          ],
        ),
        // Branch 4: Absensi
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.attendance, // path: '/attendance'
              builder: (context, state) => const AttendanceScreen(),
            ),
          ],
        ),
      ],
    )
  ],
);