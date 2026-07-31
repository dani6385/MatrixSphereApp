// lib/navigation/app_router.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'app_navigator.dart';

import 'app_shell_branches.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/products/product_detail_screen.dart';
import '../features/products/add_product_screen.dart';
import '../screens/home/home_screen.dart';

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
  initialLocation: '/login', // Atau halaman splash screen jika ada
  navigatorKey: _rootNavigatorKey,
  redirect: (BuildContext context, GoRouterState state) {
    // Periksa status login dari Firebase Auth
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    // Dapatkan lokasi yang sedang dituju
    final String location = state.uri.toString();

    // Daftar halaman publik yang bisa diakses tanpa login
    final bool isPublicPage = location == '/login' ||
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
  refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
  routes: <RouteBase>[
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
      path: '/',
      builder: (context, state) => const HomeScreen(), // Ganti dengan halaman utama Anda
    ),
    // Rute baru untuk detail produk
    GoRoute(
      path: AppRoutes.publicProductDetail, // '/shops/:shopId/products/:productId'
      builder: (context, state) {
        // Ekstrak parameter dari path URL
        final shopId = state.pathParameters['shopId'] ?? 'ID Toko tidak ditemukan';
        final productId = state.pathParameters['productId'] ?? 'ID Produk tidak ditemukan';
        return ProductDetailScreen(
          shopId: shopId,
          productId: productId,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.productAdd, // Path: '/products/add'
      builder: (context, state) => const AddProductScreen(),
    ),
    
  ],
);