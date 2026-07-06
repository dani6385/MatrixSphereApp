import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/detail_screens/seller_detail_screen.dart';
import '../../presentation/home_screen/home_screen.dart';
import '../../presentation/seller/repositories/seller_repository.dart';
// import 'package:matrix_sphere_app/presentation/navigation/main_navigation_shell.dart';
// TODO: Uncomment MainNavigationShell jika sudah siap digunakan

/// Konfigurasi GoRouter untuk aplikasi.
final GoRouter appRouter = GoRouter(
  // Rute awal aplikasi.
  initialLocation: '/',
  // Aktifkan logging untuk membantu proses debug.
  debugLogDiagnostics: true,
  // Gunakan ShellRoute untuk membuat UI navigasi yang persisten (BottomNavigationBar).
  routes: [
    // TODO: Konfigurasi ShellRoute bisa diaktifkan kembali saat navigasi utama sudah siap.
    // ShellRoute(
    //   builder: (context, state, child) => MainNavigationShell(child: child),
    //   routes: [
    //     GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    //     // Tambahkan rute lain di dalam shell di sini
    //   ],
    // ),

    // Rute sementara tanpa ShellRoute
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/seller-detail',
      builder: (context, state) => SellerDetailScreen(troubledSeller: state.extra as TroubledSeller),
    ),
  ],
);