// lib/navigation/app_router.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/features/auth/shop_registration_screen.dart';
import 'app_navigator.dart';

import 'app_shell_branches.dart';
import 'package:shared_ui/shared_ui.dart'; // Import SplashScreen

import 'package:firebase_auth/firebase_auth.dart';

import 'app_extractor.dart';

// Ini adalah kelas helper untuk GoRouter agar bisa mendengarkan Stream
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}


final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: '/', // Mengubah initialLocation ke root
  navigatorKey: _rootNavigatorKey,
  redirect: (BuildContext context, GoRouterState state) {
    // Periksa status login dari Firebase Auth
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    // Dapatkan lokasi yang sedang dituju
    final String location = state.fullPath ?? state.uri.toString(); // Menggunakan fullPath untuk rute yang lebih akurat

    // Daftar halaman publik yang bisa diakses tanpa login
    final bool isPublicPage = location == '/' || // Menambahkan '/' sebagai halaman publik
        location == '/login' ||
        location == '/register' ||
        location == '/forgot-password'; // Sesuaikan dengan rute publik Anda

    // Skenario:
    // 1. Jika pengguna BELUM login dan TIDAK sedang menuju halaman publik,
    //    maka alihkan (redirect) ke halaman login.
    if (!isLoggedIn && !isPublicPage) {
      return '/login';
    }

    // 2. Jika pengguna SUDAH login dan sedang mencoba mengakses halaman publik,
    //    maka alihkan ke halaman utama (home).
    if (isLoggedIn && isPublicPage) {
      return '/';
    }

    // 3. Jika tidak ada kondisi di atas yang terpenuhi, jangan lakukan redirect.
    return null;
  },
  // Ini adalah bagian KRUSIAL untuk persistensi sesi dengan GoRouter
  refreshListenable:
      GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
  routes: <RouteBase>[
    // Rute untuk Splash Screen (akan ditampilkan pertama kali)
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    // StatefulShellRoute untuk halaman utama dengan Bottom Navigation Bar.
    StatefulShellRoute.indexedStack(
      // Rute-rute di dalam 'branches' akan ditampilkan di dalam AppNavigator
      builder: (context, state, navigationShell) {
        return AppNavigator(navigationShell: navigationShell);
      },
      branches: appShellBranches,
    ),

    // Rute-rute di luar Shell (misalnya, halaman login, register, dll.)
    // Ini penting agar redirect berfungsi dengan benar.
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/shop-registration',
      builder: (context, state) => const ShopRegistrationScreen(),
    ),
  ],
);
