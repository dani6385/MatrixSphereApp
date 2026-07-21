import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../navigation/app_navigator.dart';
import '../screens/account/account_screen.dart';
import '../screens/bottom_mobile/attendance/attendance_screen.dart';
import '../screens/approval/approval_screen.dart';
import '../screens/approval/approval_detail_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/bottom_mobile/home/home_screen.dart';
import '../screens/bottom_mobile/sellers/seller_screen.dart';
import '../screens/bottom_mobile/status/status_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/absensi/camera_absen_screen.dart';
import '../screens/access/access_screen.dart'; // <-- Impor halaman baru
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
        // Branch 1: Seller
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.aktifitas,
              builder: (context, state) => const SellerScreen()),
        ]),
        // Branch 2: Approval
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.approval, // Diperbaiki dari AppRoutes.sellers
              builder: (context, state) => const ApprovalScreen()),
        ]),
        // Branch 3: Status
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.status,
              builder: (context, state) => const StatusScreen()),
        ]),
        // Branch 4: Attendance (Absensi)
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.attendance,
              builder: (context, state) => const AttendanScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.attendanceProvider,
              builder: (context, state) => const AttendanScreen()),
        ]),
        // Branch 5: Calendar (Kalender)
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.calendar,
              builder: (context, state) => const CalendarScreen()),
        ]),
        // Branch 6: Account (Akun)
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.account,
              builder: (context, state) => const AccountScreen()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingScreen()),
        ]),
      ],
    ),
    // Rute di luar ShellRoute
    GoRoute(
      path: AppRoutes.approvalDetail,
      builder: (context, state) => const ApprovalDetailScreen(
        approvalId: '',
      ),
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
