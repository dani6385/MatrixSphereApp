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
  
  navigatorKey: _rootNavigatorKey,
  redirect: (BuildContext context, GoRouterState state) {
    
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
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const HomeScreen(), // Ganti dengan halaman utama Anda
    ),
    /*GoRoute(
      path: '/shop-registration',
      builder: (context, state) => const ShopRegistrationScreen(),
    ),*/
  ],
);
