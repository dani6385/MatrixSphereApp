import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere_app/presentation/aprops/user_aprop.dart';
import 'package:matrix_sphere_app/presentation/home_screen/home_screen.dart';
import 'package:matrix_sphere_app/presentation/registration_screens/list/seller_registration_list_screen.dart';
import 'package:matrix_sphere_app/presentation/seller_screens/seller_monitoring_screen.dart';
import 'package:matrix_sphere_app/widget/app_navigation.dart';

import '../../presentation/aprops/register_seller_screen.dart';

// Kunci navigator global untuk rute root
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Konfigurasi GoRouter untuk aplikasi.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Rute yang berdiri sendiri (tanpa BottomNavBar)
    GoRoute(
      path: '/register-seller',
      builder: (context, state) => const RegisterSellerScreen(),
    ),
    GoRoute(
      path: '/seller-registrations',
      builder: (context, state) => const SellerRegistrationListScreen(),
    ),

    // Rute utama dengan BottomNavBar menggunakan ShellRoute
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Widget AppNavigation bertindak sebagai UI shell
        return AppNavigation(navigationShell: navigationShell);
      },
      branches: [
        // Cabang untuk tab "Home"
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (BuildContext context, GoRouterState state) =>
                  const HomeScreen(),
            ),
          ],
        ),

        // Cabang untuk tab "Aprop"
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/aprop',
              builder: (BuildContext context, GoRouterState state) =>
                  const UserApropScreen(),
            ),
          ],
        ),

        // Cabang untuk tab "Mitra"
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/mitra',
              builder: (BuildContext context, GoRouterState state) =>
                  const SellerMonitoringScreen(),
            ),
          ],
        ),
        
        // Cabang untuk tab "Akun"
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/akun',
              // Ganti dengan halaman Akun Anda yang sebenarnya
              builder: (BuildContext context, GoRouterState state) =>
                  const Scaffold(body: Center(child: Text("Halaman Akun"))),
            ),
          ],
        ),
      ],
    ),
  ],
);
