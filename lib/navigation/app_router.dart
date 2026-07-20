import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:matrix_sphere/navigation/app_navigator.dart';
import 'package:matrix_sphere/routes/app_routes.dart';

// Import semua layar Anda di sini
import '../screens/home/home_screen.dart';
import '../screens/sellers/seller_screen.dart';
import '../screens/approval/approval_screen.dart';
import '../screens/system/system_screen.dart';
import '../screens/attendance/attendance_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/account/account_screen.dart';
import '../screens/approval/approval_detail_screen.dart';

// Kunci navigator global
final _rootNavigatorKey = GlobalKey<NavigatorState>();

// --- KONFIGURASI ROUTER --- //

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  navigatorKey: _rootNavigatorKey,
  routes: [
    // Rute Shell Utama untuk Navigasi dengan BottomBar/NavRail
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Widget AppNavigator menjadi UI shell
        return AppNavigator(navigationShell: navigationShell);
      },
      // Gunakan cabang yang berbeda berdasarkan platform
      branches: kIsWeb ? _webBranches : _mobileBranches,
    ),

    // Rute non-shell (yang akan tampil di atas shell, tanpa nav bar)
    // Contoh: Layar detail
    GoRoute(
      path: '${AppRoutes.approval}/:id', // Contoh: /approval/some_id
      name: AppRoutes.approvalDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ApprovalDetailScreen(approvalId: id);
      },
    ),
  ],
);

// --- CABANG NAVIGASI (BRANCHES) --- //

// Cabang untuk platform Mobile (Android/iOS) - 5 item
final List<StatefulShellBranch> _mobileBranches = [
  // 0: Home
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
  ]),
  // 1: Seller
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.sellers,
        builder: (context, state) => const SellerScreen()),
  ]),
  // 2: Approval
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.approval,
        builder: (context, state) => const ApprovalScreen()),
  ]),
  // 3: Absensi
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.attendance,
        builder: (context, state) => const AttendanceScreen()),
  ]),
  // 4: Akun
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.system,
        builder: (context, state) => const AccountScreen()),
  ]),
];

// Cabang untuk platform Web - 7 item
final List<StatefulShellBranch> _webBranches = [
  // 0: Home
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
  ]),
  // 1: Seller
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.sellers,
        builder: (context, state) => const SellerScreen()),
  ]),
  // 2: Approval
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.approval,
        builder: (context, state) => const ApprovalScreen()),
  ]),
  // 3: System
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.system,
        builder: (context, state) => const SystemScreen()),
  ]),
  // 4: Absensi
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.attendance,
        builder: (context, state) => const AttendanceScreen()),
  ]),
  // 5: Kalender
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.calendar,
        builder: (context, state) => const CalendarScreen()),
  ]),
  // 6: Akun
  StatefulShellBranch(routes: [
    GoRoute(
        path: AppRoutes.account,
        builder: (context, state) => const AccountScreen()),
  ]),
];
