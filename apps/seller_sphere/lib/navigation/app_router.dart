// app_router.dart

import 'package:flutter/material.dart';
import 'package:seller_sphere/navigation/app_navigator.dart';
import 'package:seller_sphere/navigation/custom_transition_page.dart';
import 'package:go_router/go_router.dart';

//import 'package:shared_ui/shared_ui.dart';
//import 'package:shared_services/shared_services.dart';
import 'app_extraktor.dart';

import 'app_routes.dart';

// Kunci GlobalKey untuk NavigatorShell, diperlukan untuk StatefulShellRoute
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// Placeholder screen untuk fitur yang belum dibuat
class AppRouter extends StatelessWidget {
  final String title;

  const AppRouter({super.key, required this.title});
  //const AppRouter({super.key, required this.title, required AuthBloc authBloc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Layar untuk $title')),
    );
  }
}

/// Daftar branch untuk StatefulShellRoute.
/// Diekstrak agar bisa diakses oleh widget navigasi (misal: BottomNavBar).
final List<StatefulShellBranch> appShellBranches = <StatefulShellBranch>[
  // Setiap branch mewakili satu item di BottomNavigationBar
  // Branch 0: Home
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.home, // path: '/'
        pageBuilder: (context, state) => FadeTransitionPage(
          child: const HomeScreen(),
        ),
      ),
    ],
  ),
  // Branch 1: Stream
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.stream, // path: '/stream'
        pageBuilder: (context, state) => FadeTransitionPage(
          child: const StreamingScreen(streamId: '',),
        ),
      ),
    ],
  ),
  // Branch 2: Inventory
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.management, // path: '/inventory'
        pageBuilder: (context, state) => FadeTransitionPage(
          child: const ManagementScreen(),
        ),
      ),
    ],
  ),
  // Branch 3: Sellers/Kios
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.sellers, // path: '/sellers'
        pageBuilder: (context, state) => FadeTransitionPage(
          child: const SellerScreen(),
        ),
      ),
    ],
  ),
  // Branch 4: Absensi
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.attendance, // path: '/attendance'
        pageBuilder: (context, state) => FadeTransitionPage(
          child: const AttendanceScreen(),
        ),
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute( // path: '/productform'
        path: AppRoutes.productForm,
        pageBuilder: (context, state) => FadeTransitionPage(
          child: const ProductFormScreen(),
        ),
      ),
    ],
  ),
];

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
      branches: appShellBranches,
    ),
    // --- RUTE NON-TAB (seperti login, profile, dll) HARUS DIDAFTARKAN DI SINI ---
    /*GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),*/
    // ... tambahkan rute lain seperti editprofile, register, dll di sini
  ],
);