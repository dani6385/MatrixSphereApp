// Disimpan di packages/shared_navigation/lib/routes/app_shell_branches.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<StatefulShellBranch> appShellBranches({
  required Widget case0Screen, // Contoh: Home / Beranda
  required Widget case1Screen, // Contoh: Approvals (Matrix) atau Financial (Seller)
  required Widget case2Screen, // Contoh: Analytics (Matrix) atau Management (Seller)
  required Widget case3Screen, // Contoh: Transactions (Matrix) atau Sellers (Seller)
  required Widget case4Screen,
  GlobalKey<NavigatorState>? homeNavigatorKey,
  
}) {
  return [
    // Branch untuk Tab Home
    StatefulShellBranch(
      navigatorKey: homeNavigatorKey,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => case0Screen,
        ),
      ],
    ),
    StatefulShellBranch(
      navigatorKey: homeNavigatorKey,
      routes: [
        GoRoute(
          path: '/case1',
          builder: (context, state) => case1Screen,
        ),
      ],
    ),
    StatefulShellBranch(
      navigatorKey: homeNavigatorKey,
      routes: [
        GoRoute(
          path: '/case2',
          builder: (context, state) => case2Screen,
        ),
      ],
    ),
    // Branch untuk Tab Financial / Stream
    StatefulShellBranch(
      navigatorKey: homeNavigatorKey,
      routes: [
        GoRoute(
          path: '/case3',
          builder: (context, state) => case3Screen,
        ),
      ],
    ),
    // Branch untuk Tab Attendance
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/case',
          builder: (context, state) => case4Screen,
        ),
      ],
    ),
  ];
}
