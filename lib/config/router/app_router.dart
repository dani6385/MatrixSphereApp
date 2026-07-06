import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere_app/presentation/home_screen/home_screen.dart';
import 'package:matrix_sphere_app/screens/approval/approval_screen.dart';
import 'package:matrix_sphere_app/presentation/achievement/achievement_screen.dart';
import 'package:matrix_sphere_app/presentation/registration_screens/detail/seller_registration_detail_screen.dart';
// Impor model untuk casting data
import 'package:matrix_sphere_app/presentation/registration_screens/models/registration_models.dart'; 
import 'package:matrix_sphere_app/widget/app_navigation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/persetujuan/detail',
      builder: (context, state) {
        // Ekstrak objek SellerRegistration dari parameter 'extra'
        final seller = state.extra as SellerRegistration;
        return SellerRegistrationDetailScreen(seller: seller);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (BuildContext context, GoRouterState state) =>
                  const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/persetujuan',
              builder: (BuildContext context, GoRouterState state) =>
                  const ApprovalScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/prestasi',
              builder: (BuildContext context, GoRouterState state) =>
                  const AchievementScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/akun',
              builder: (BuildContext context, GoRouterState state) =>
                  const Scaffold(body: Center(child: Text("Halaman Akun"))),
            ),
          ],
        ),
      ],
    ),
  ],
);
