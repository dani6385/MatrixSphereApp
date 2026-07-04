import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/account_screen/account_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/status_screen/status_screen.dart';
import '../presentation/transaction_screen/transaction_screen.dart';
import '../widgets/app_scaffold.dart';
import '../providers/auth_provider.dart';
import '../utils/go_router_refresh_stream.dart'; // Impor file baru

class AppRoutes {
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String homeScreen = '/home-screen';
  static const String statusScreen = '/status-screen';
  static const String transactionScreen = '/transaction-screen';
  static const String accountScreen = '/account-screen';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.initial,
    refreshListenable: GoRouterRefreshStream(ref.read(authNotifierProvider.notifier).stream),
    redirect: (context, state) {
      // Ambil state terbaru di dalam redirect untuk memastikan nilainya tidak basi.
      final authState = ref.watch(authNotifierProvider);
      final isAuthenticated = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == AppRoutes.initial || state.matchedLocation == AppRoutes.loginScreen;

      if (!isAuthenticated && !isLoggingIn) {
        return AppRoutes.loginScreen;
      }
      if (isAuthenticated && isLoggingIn) {
        return AppRoutes.homeScreen;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.initial,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 280),
        ),
      ),
      GoRoute(
        path: AppRoutes.loginScreen,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 280),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.homeScreen,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.statusScreen,
                builder: (context, state) => const StatusScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.transactionScreen,
                builder: (context, state) => const TransactionScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.accountScreen,
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
