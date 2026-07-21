import 'package:go_router/go_router.dart';
import '../navigation/app_navigator.dart';
import '../screens/account/account_screen.dart';
import '../screens/attendance/attendance_screen.dart';
import '../screens/approval/approval_screen.dart';
import '../screens/approval/approval_detail_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/sellers/seller_screen.dart';
import '../screens/system/system_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/settings/setting_screen.dart';
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
        // Branch 3: System
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.system,
              builder: (context, state) => const SystemScreen()),
        ]),
        // Branch 4: Attendance (Absensi)
        StatefulShellBranch(routes: [
          GoRoute(
              path: AppRoutes.attendance,
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
  ],
);
