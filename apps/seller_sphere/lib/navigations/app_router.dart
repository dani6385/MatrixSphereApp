import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_navigator.dart';
import 'app_shell_branches.dart';
import 'app_extractor.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  // Kita mulai dari rute awal di salah satu branch, yaitu Home ('/')
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
  routes: <RouteBase>[
    // Ini adalah Shell Route utama yang berisi BottomNavBar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Shell ini akan selalu menggunakan AppNavigator sebagai UI-nya
        return AppNavigator(navigationShell: navigationShell);
      },
      // Branches berisi daftar navigasi yang akan memiliki BottomNavBar
      branches: appShellBranches,
    ),

    // --- TEMPAT UNTUK RUTE FULLSCREEN ---
    // Nanti, jika Anda butuh halaman login atau halaman detail fullscreen,
    // definisikan di sini, di luar StatefulShellRoute.
    // Contoh:
    // GoRoute(
    //   path: '/login',
    //   parentNavigatorKey: _rootNavigatorKey, // Gunakan root key
    //   builder: (context, state) => const LoginScreen(),
    // ),
    GoRoute(
    path: '/profile',
    parentNavigatorKey: _rootNavigatorKey, // Gunakan root key
    builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
