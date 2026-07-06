import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/detail_screens/seller_detail_screen.dart';
import '../../presentation/home_screen/home_screen.dart';
import '../../presentation/seller/repositories/seller_repository.dart';
import '../../presentation/home_screen/main_navigation_shell.dart';

/// Konfigurasi GoRouter untuk aplikasi.
final GoRouter appRouter = GoRouter(
  // Rute awal aplikasi.
  initialLocation: '/',
  // Aktifkan logging untuk membantu proses debug.
  debugLogDiagnostics: true,
  // Gunakan ShellRoute untuk membuat UI navigasi yang persisten (BottomNavigationBar).
  routes: [
    // Gunakan ShellRoute untuk menampilkan BottomNavigationBar
    ShellRoute(
      builder: (context, state, child) => MainNavigationShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        // Tambahkan rute lain untuk tab navigasi di sini
        GoRoute(
          path: '/settings',
          // Ganti dengan layar Pengaturan Anda yang sebenarnya
          builder: (context, state) => const Scaffold(body: Center(child: Text("Halaman Pengaturan"))),
        ),
      ],
    ),    
    GoRoute(
      path: '/seller-detail',
      builder: (context, state) => SellerDetailScreen(troubledSeller: state.extra as TroubledSeller),
    ),
  ],
);