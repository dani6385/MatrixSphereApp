import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_navigator.dart';
import 'package:seller_sphere/screens/account/account_screen.dart';
//import 'package:seller_sphere/screens/bottom_mobile/attendance/attendance_screen.dart';

import 'package:seller_sphere/screens/calendar/calendar_screen.dart';
import 'package:seller_sphere/screens/home/home_screen.dart';
import 'package:seller_sphere/screens/inventoris/inventory_screen.dart';
//import 'package:seller_sphere/screens/streams/streaming_screen.dart';
//import 'package:seller_sphere/screens/status/status_screen.dart';
import 'package:seller_sphere/screens/chat/chat_screen.dart';
import 'package:seller_sphere/screens/absensi/camera_absen_screen.dart';
import 'package:seller_sphere/screens/access/access_screen.dart'; // <-- Impor halaman baru
import 'package:seller_sphere/screens/settings/setting_screen.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppNavigator(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        // Branch 0: Home
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen()),
        ]),
        // Branch 1: Streams
        /*StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.stream,
              builder: (context, state) => const StreamingScreen()),
        ]),*/
        // Branch 2: Status
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.inventory,
              builder: (context, state) => InventoryScreen(onNavigateToLabelPrinter: (product) {})),
        ]),
        // Branch 4: Attendance (Absensi)
        /*StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.attendance,
              builder: (context, state) => const AttendanceScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.attendanceProvider,
              builder: (context, state) => const AttendanceScreen()),
        ]),*/
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.calendar,
              builder: (context, state) => const CalendarScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.account,
              builder: (context, state) => const AccountScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingScreen())
        ]),
      ],
    ),
    GoRoute(
      path: AppRoutes.chat,
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: AppRoutes.camera, // Rute URL kamera
      builder: (context, state) =>
          const CameraAbsenScreen(), // Memanggil layar kamera
    ),
    GoRoute(
      path: AppRoutes.access,
      builder: (context, state) => const AccessScreen(),
    ),
    // Placeholder untuk halaman-halaman dari menu akses
    GoRoute(
      path: AppRoutes.goodsIn,
      builder: (context, state) => const _PlaceholderScreen(title: 'Input Barang'),
    ),
    GoRoute(
      path: AppRoutes.manageStock,
      builder: (context, state) => const _PlaceholderScreen(title: 'Kelola Stok'),
    ),
    GoRoute(
      path: AppRoutes.goodsOut,
      builder: (context, state) => const _PlaceholderScreen(title: 'Pengeluaran Barang'),
    ),
  ],
);

// Widget placeholder sederhana untuk menunjukkan navigasi berhasil
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)));
  }
}
