import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/main_scafold.dart';

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
    // ShellRoute akan membungkus semua rute di dalamnya dengan MainScaffold
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        // Rute untuk setiap tab
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.aktifitas,
          builder: (context, state) => const SellerScreen(),
        ),
        GoRoute(
          path: AppRoutes.approval,
          builder: (context, state) => const ApprovalScreen(),
        ),
        GoRoute(
          path: AppRoutes.attendance,
          builder: (context, state) => const AttendanceScreen(),
        ),
        GoRoute(
          path: AppRoutes.system,
          builder: (context, state) => const SystemScreen(),
        ),
        GoRoute(
          path: '/settings', // Contoh rute tanpa konstanta
          builder: (context, state) =>
              const Scaffold(body: Center(child: Text('Settings Page'))),
        ),
      ],
    ),

    // Rute ini berada di LUAR ShellRoute, sehingga tidak akan ada Bottom Nav Bar
    GoRoute(
      path: AppRoutes.approvalDetail,
      builder: (context, state) => const ApprovalDetailScreen(),
    ),
  ],
);
