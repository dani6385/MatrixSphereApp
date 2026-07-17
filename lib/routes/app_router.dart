//import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_navigator.dart';
import '../screens/attendance/attendance_screen.dart';
import '../screens/approval/approval_screen.dart';
import '../screens/approval/approval_detail_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/seller/seller_screen.dart';
import '../screens/system/system_screen.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    // StatefulShellRoute untuk navigasi dengan BottomNavBar yang menjaga state
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // 'navigationShell' adalah widget yang berisi halaman-halaman (IndexedStack)
        // dan fungsi untuk bernavigasi. Kita teruskan ke AppNavigator.
        return AppNavigator(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        // Branch 0: Home
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen()),
        ]),
        // Branch 1: Seller
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.aktifitas,
              builder: (context, state) => const SellerScreen()),
        ]),
        // Branch 2: Approval
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.approval,
              builder: (context, state) => const ApprovalScreen()),
        ]),
        // Branch 3: System
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.system,
              builder: (context, state) => const SystemScreen()),
        ]),
        // Branch 4: Attendance
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.attendance,
              builder: (context, state) => const AttendanceScreen()),
        ]),
      ],
    ),

    // Rute ini berada di LUAR ShellRoute, sehingga tidak akan ada Bottom Nav Bar
    GoRoute(
      path: AppRoutes.approvalDetail,
      builder: (context, state) => const ApprovalDetailScreen(
        approvalId: '',
      ),
    ),
  ],
);
