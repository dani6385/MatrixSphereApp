import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_screens/shared_screens.dart';
import 'package:shared_services/shared_services.dart';
import 'app_routes.dart';

/// Membangun rute fullscreen untuk modul autentikasi menggunakan shared_screens.
List<RouteBase> buildAuthRoutes({GlobalKey<NavigatorState>? rootNavigatorKey}) {
  return [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGate(),
    ),
    GoRoute(
      path: AppRoutes.login,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.userRegistration,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const UserRegistrationScreen(),
    ),
    GoRoute(
      path: AppRoutes.shopRegistration,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ShopRegistrationScreen(),
    ),
  ];
}

/// Membangun branch shell untuk navigasi otentikasi.
List<StatefulShellBranch> authShellBranches({
  Widget? onboardScreen,
  Widget? loginScreen,
  Widget? registrationScreen,
  Widget? forgotScreen,
  GlobalKey<NavigatorState>? homeNavigatorKey,
}) {
  return [
    if (onboardScreen != null)
      StatefulShellBranch(
        navigatorKey: homeNavigatorKey,
        routes: [
          GoRoute(
            path: '/onboard',
            builder: (context, state) => onboardScreen,
          ),
        ],
      ),
    StatefulShellBranch(
      navigatorKey: homeNavigatorKey,
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => loginScreen ?? const LoginScreen(),
        ),
      ],
    ),
    StatefulShellBranch(
      navigatorKey: homeNavigatorKey,
      routes: [
        GoRoute(
          path: AppRoutes.userRegistration,
          builder: (context, state) =>
              registrationScreen ?? const UserRegistrationScreen(),
        ),
      ],
    ),
    StatefulShellBranch(
      navigatorKey: homeNavigatorKey,
      routes: [
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) =>
              forgotScreen ?? const ForgotPasswordScreen(),
        ),
      ],
    ),
  ];
}

