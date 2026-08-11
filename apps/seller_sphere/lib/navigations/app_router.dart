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