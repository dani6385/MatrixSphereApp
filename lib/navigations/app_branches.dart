import 'package:shared_navigations/shared_navigations.dart';
import 'app_extractor.dart';
import 'package:go_router/go_router.dart';

final appBranches = <StatefulShellBranch>[
  StatefulShellBranch(routes: [
    GoRoute(
      path: '/', // Jadikan ini sebagai rute default untuk shell
      builder: (context, state) => const HomeScreen(),
    ),
  ]),
  StatefulShellBranch(routes: [
    GoRoute(
      path: AppRoutes.approvals, // Menggunakan '/approvals'
      builder: (context, state) => const ApprovalScreen(),
    ),
  ]),
  StatefulShellBranch(routes: [
    GoRoute(
      path: AppRoutes.analytics, // Menggunakan '/analytics'
      builder: (context, state) => const AnalyticScreen(),
    ),
  ]),
  StatefulShellBranch(routes: [
    GoRoute(
      path: AppRoutes.transactions, // Menggunakan '/transactions'
      builder: (context, state) => const ProjectScreen(),
    ),
  ]),
  StatefulShellBranch(routes: [
    GoRoute(
      path: AppRoutes.attendance, // Menggunakan '/attendance'
      builder: (context, state) => const AttendanceScreen(),
    ),
  ]),
];