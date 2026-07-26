// app_router.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/bottom_nav_bar.dart';


import 'package:shared_services/shared_services.dart';
import 'app_extraktor.dart';

import 'app_routes.dart';

// Kunci GlobalKey untuk NavigatorShell, diperlukan untuk StatefulShellRoute
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// The main router configuration for the application.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.login, // Mulai dari halaman login
  debugLogDiagnostics: true, // Set to false in production
  redirect: (BuildContext context, GoRouterState state) {
    // Gunakan status langsung dari FirebaseAuth untuk menghindari race condition
    // dengan state BLoC. Ini lebih andal untuk redirect.
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    // Dapatkan lokasi yang sedang dituju
    final String location = state.uri.toString();

    // Daftar halaman publik yang bisa diakses tanpa login
    final bool isPublicPage = location == AppRoutes.login ||
        location == '/login/register' || // Ganti dengan AppRoutes jika ada
        location == '/login/forgot-password'; // Ganti dengan AppRoutes jika ada

    // Skenario:
    // - Jika pengguna BELUM login dan TIDAK sedang menuju halaman publik,
    //   maka alihkan (redirect) ke halaman login.
    if (!isLoggedIn && !isPublicPage) {
      return AppRoutes.login;
    }

    // - Jika pengguna SUDAH login dan sedang mencoba mengakses halaman publik,
    //   maka alihkan ke halaman utama (home).
    if (isLoggedIn && isPublicPage) {
      return AppRoutes.home;
    }

    // - Jika tidak ada kondisi di atas yang terpenuhi, jangan lakukan redirect.
    return null;
  },
  refreshListenable:
      GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  routes: <RouteBase>[
    // Rute yang memiliki BottomNavigationBar (di dalam Shell)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Bungkus navigationShell (konten halaman) dan BottomNavBar
        // di dalam sebuah Scaffold.
        return Scaffold(
          body:
              navigationShell, // navigationShell akan menampilkan halaman aktif
          bottomNavigationBar: BottomNavBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(index),
          ),
        );
      },
      branches: [
        // Branch 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Branch 2: Streaming (Sesuai urutan di bottom_nav_bar.dart)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.stream,
              builder: (context, state) => const StreamingScreen(),
            ),
          ],
        ),
        // Branch 3: Status (orderan)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.status,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Status'))),
            ),
          ],
        ),
        // Branch 4: Absen (Attendance)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.attendance,
              builder: (context, state) => const AttendanceScreen(),
            ),
          ],
        ),
      ],
    ),

    // Rute yang TIDAK memiliki BottomNavigationBar (fullscreen)
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    // Tambahkan rute fullscreen lain di sini (register, forgot-password, dll.)
  ],

  // Halaman error jika rute tidak ditemukan
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
);