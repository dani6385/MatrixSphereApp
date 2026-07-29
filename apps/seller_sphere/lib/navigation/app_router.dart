import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_extraktor.dart';


import 'app_routes.dart';

// 1. Definisikan GlobalKey untuk navigator
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// 2. Definisikan cabang-cabang untuk StatefulShellRoute
final List<StatefulShellBranch> appShellBranches = [
  // Branch 1: Home
  StatefulShellBranch(routes: [
    GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
  ]),
  // Branch 2: Stream
  StatefulShellBranch(routes: [
    GoRoute(path: AppRoutes.stream, builder: (context, state) => const StreamingScreen(streamId: 'default_stream')),
  ]),
  // Branch 3: Management
  StatefulShellBranch(routes: [
    GoRoute(path: AppRoutes.management, builder: (context, state) => const ManagementScreen()),
  ]),
  // Branch 4: Sellers (Inventory)
  StatefulShellBranch(routes: [
    GoRoute(path: AppRoutes.sellers, builder: (context, state) => const SellerScreen()),
  ]),
  // Branch 5: Attendance
  StatefulShellBranch(routes: [
    GoRoute(path: AppRoutes.attendance, builder: (context, state) => const AttendanceScreen()),
  ]),
];

// Buat instance GoRouter
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.management, // Lokasi awal aplikasi
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    // 3. Gunakan StatefulShellRoute untuk halaman dengan BottomNavBar
    StatefulShellRoute.indexedStack(
      // Cukup kembalikan navigationShell. Scaffold akan dibuat oleh halaman itu sendiri.
      // BottomNavBar akan ditambahkan di dalam Scaffold halaman.
      builder: (context, state, navigationShell) => navigationShell,
      branches: appShellBranches,
    ),

    // 4. Rute fullscreen (tanpa BottomNavBar)
    GoRoute(path: AppRoutes.chat, builder: (context, state) => const ChatScreen()),
  ],
  // Halaman error jika rute tidak ditemukan
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Error')),
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
);