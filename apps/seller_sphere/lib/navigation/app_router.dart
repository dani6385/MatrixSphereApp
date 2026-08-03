// lib/navigation/app_router.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/features/auth/shop_registration_screen.dart';
import 'package:seller_sphere/navigation/app_shell.dart';

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
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  redirect: (BuildContext context, GoRouterState state) {
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final String location = state.fullPath ?? state.uri.toString();

    final bool isPublicPage =
        location == '/login' ||
        location == '/register' ||
        location == '/forgot-password';

    final bool isOnSplashScreen = location == '/';

    if (!isLoggedIn) {
      if (isOnSplashScreen || !isPublicPage) {
        return '/login';
      }
    }

    if (isLoggedIn) {
      if (isOnSplashScreen || isPublicPage) {
        return '/home';
      }
    }

    return null;
  },
  refreshListenable:
      GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: appShellBranches,
    ),
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
