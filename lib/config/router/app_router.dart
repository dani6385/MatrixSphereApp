import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/main_screens/main_screen.dart';
import '../../presentation/login_screens/login_screen.dart';
import '../../presentation/two_factor_screen/two_factor_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MainScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/two_factor',
      builder: (BuildContext context, GoRouterState state) {
        return const TwoFactorScreen();
      },
    ),
  ],
);
