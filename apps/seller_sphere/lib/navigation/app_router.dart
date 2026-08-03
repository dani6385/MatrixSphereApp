// lib/navigation/app_router.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_navigator.dart';
import 'app_shell_branches.dart';
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
  refreshListenable:
      GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
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
      builder: (context, state) =>
          const HomeScreen(), // Ganti dengan halaman utama Anda
    ),
    GoRoute(
      path: '/shop-registration',
      builder: (context, state) => const ShopRegistrationScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const PublicProductScreen(),
    ),
    GoRoute(
      path: '/addproducts',
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: '/product-detail/:id',
      builder: (context, state) {
        final String productId = state.pathParameters['id']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/edit-product/:id',
      builder: (context, state) {
        state.pathParameters['id']!;
        return const AddProductScreen();
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/attendance',
      builder: (context, state) => const AttendanceScreen(),
    ),
    GoRoute(
      path: '/management',
      builder: (context, state) => const ManagementScreen(),
    ),
    GoRoute(
      path: '/sellers',
      builder: (context, state) => const SellerScreen(),
    ),
    GoRoute(
      path: '/streaming',
      builder: (context, state) => const StreamingScreen(streamId: '',),
    ),
    
  ],
);

extension GoRouterExtension on GoRouter {
  String get location {
    return routerDelegate.currentConfiguration.uri.toString();
  }
}
