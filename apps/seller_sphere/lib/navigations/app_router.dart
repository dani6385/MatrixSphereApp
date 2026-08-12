<<<<<<< HEAD
<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'shell_route_config.dart';
import 'fullscreen_routes.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  // Kita mulai dari rute awal di salah satu branch, yaitu Home ('/')
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
  routes: <RouteBase>[
    buildAppShellRoute(),
    ...buildFullscreenRoutes(_rootNavigatorKey),
  ],
=======
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import 'shell_route_config.dart';


import 'fullscreen_routes.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  // Kita mulai dari rute awal di salah satu branch, yaitu Home ('/')
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
  routes: <RouteBase>[
    buildAppShellRoute(),
    ...buildFullscreenRoutes(_rootNavigatorKey),
  ],
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
);
=======
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'package:shared_services/auth/auth_service.dart';
import 'shell_route_config.dart';
import 'fullscreen_routes.dart';

// Kunci global untuk navigator utama (root)
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  // Kita mulai dari rute awal di salah satu branch, yaitu Home ('/')
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
  redirect: (BuildContext context, GoRouterState state) async {
    final AuthService authService = AuthService();
    final bool isLoggedIn = authService.isLoggedIn();
    final String currentPath = state.matchedLocation;

    // Izinkan akses bebas untuk halaman Login, Register, dan Forgot Password
    final bool isAuthRoute = currentPath == AppRoutes.login ||
        currentPath == AppRoutes.register ||
        currentPath == AppRoutes.forgotPassword;
    // Jika belum login dan tidak sedang di halaman auth, lempar ke login
    if (!isLoggedIn && !isAuthRoute) {
      return AppRoutes.login;
    }
    // 2. Jika sudah login, cegah agar tidak bisa masuk ke halaman login/register lagi, lalu cek toko
    if (isLoggedIn) {
      // Jika sudah login dan mencoba akses halaman login/register, lempar ke home.
      if (currentPath == AppRoutes.login || currentPath == AppRoutes.register) {
        return AppRoutes.home;
      }
      // Cek status toko pengguna
      final shopStatus = await authService.getUserShopStatus();
      final bool hasApprovedShop = shopStatus == ShopStatus.approved;
      final bool isAtShopRegistration =
          state.matchedLocation == AppRoutes.shopRegistration;

      // Jika toko belum disetujui (status 'none' atau 'pending') dan tidak sedang di halaman registrasi,
      // paksa arahkan ke halaman registrasi/status.
      if (!hasApprovedShop && !isAtShopRegistration) {
        return AppRoutes.shopRegistration;
      }
      // Jika toko sudah disetujui tapi mencoba akses halaman registrasi, kembalikan ke home.
      if (hasApprovedShop && isAtShopRegistration) {
        return AppRoutes.home;
      }
    }
    return null;
  },
  routes: <RouteBase>[
    buildAppShellRoute(),
    ...buildFullscreenRoutes(_rootNavigatorKey),
  ],
);
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
