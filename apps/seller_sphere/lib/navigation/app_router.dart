import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_extraktor.dart';
import 'package:seller_sphere/navigation/bottom_nav_bar.dart';

import 'app_routes.dart';

// 1. Definisikan GlobalKey untuk navigator
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// 2. Definisikan cabang-cabang untuk StatefulShellRoute
final List<StatefulShellBranch> appShellBranches = [
  // Branch 1: Home
  StatefulShellBranch(routes: [
    GoRoute(
        path: '/',
        builder: (context, state) =>
            const HomeScreen()),
  ]),
  // Branch 2: Stream
  StatefulShellBranch(routes: [
    GoRoute(
        path: '/stream',
        builder: (context, state) =>
            const StreamingScreen(streamId: 'default_stream')),
  ]),
  // Branch 3: Management
  StatefulShellBranch(routes: [
    GoRoute(
        path: '/management',
        builder: (context, state) =>
            const ManagementScreen()),
  ]),
  // Branch 4: Sellers (Inventory)
  StatefulShellBranch(routes: [
    GoRoute(
        path: '/sellers',
        builder: (context, state) =>
            const SellerScreen()),
  ]),
  // Branch 5: Attendance
  StatefulShellBranch(routes: [
    GoRoute(
        path: '/attendance',
        builder: (context, state) =>
            const AttendanceScreen()),
  ]),
];

// Buat instance GoRouter
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home, // Lokasi awal aplikasi
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    // 3. Gunakan StatefulShellRoute untuk halaman dengan BottomNavBar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: BottomNavBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(index),
          ),
        );
      },
      branches: appShellBranches,
    ),

    // 4. Rute fullscreen (tanpa BottomNavBar)
    GoRoute(
        path: AppRoutes.chat, builder: (context, state) => const ChatScreen()),
  ],
  // Halaman error jika rute tidak ditemukan
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
);
