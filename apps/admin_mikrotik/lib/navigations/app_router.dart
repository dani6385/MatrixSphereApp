import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_branches.dart';
import 'bottom_nav_bar.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_navigations/shared_navigations.dart';

//import 'shell_route_config.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  //refreshListenable: AuthRedirectNotifier(),

  // 1. Tambahkan observer analitik di sini. Ini adalah lokasi yang benar.
  observers: [
    analyticsService.analitycsObserver,
  ],
  // Redirect tidak lagi diperlukan, karena '/' akan menjadi rute yang valid.
  errorBuilder: (context, state) {
    // 2. Gunakan layanan terpusat untuk melaporkan error navigasi
    crashlyticsService.recordError(
      state.error ?? 'GoRouter Navigation Error',
      StackTrace.current,
      reason: 'Kesalahan Navigasi GoRouter di path: ${state.uri.toString()}',
    );

    // Tampilkan halaman error yang informatif kepada pengguna
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Oops! Terjadi kesalahan.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Halaman yang Anda tuju tidak dapat ditemukan. Kami telah mencatat error ini dan akan segera memperbaikinya.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => AppNavigation.goBack(context), // Arahkan kembali ke halaman utama
                child: const Text('Kembali ke Home'),
              ),
            ],
          ),
        ),
      ),
    );
  },
  routes: [
    buildAppShellRoute(
      shellBuilder: (context, state, navigationShell) {
        // shellBuilder harus mengembalikan widget shell UI.
        // Widget BottomNavBar sudah berisi Scaffold dan akan menampilkan navigationShell.
        return BottomNavBar(
          navigationShell: navigationShell,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index),
        );
      },
      branches: appBranches, // Daftar cabang rute khusus Matrix
    ),
  ],
);
