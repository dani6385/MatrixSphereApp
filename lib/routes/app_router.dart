import 'package:flutter/material.dart';
import 'package:matrix_sphere/main.dart';


import '../screens/attendance/attendance_screen.dart';
import '../screens/approval/approval_screen.dart';
import '../screens/approval/approval_detail_screen.dart'; // Impor baru
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case AppRoutes.approval:
        return MaterialPageRoute(builder: (_) => const ApprovalScreen());
      case AppRoutes.attendance:
        return MaterialPageRoute(builder: (_) => const AttendanceScreen());
      case AppRoutes.approvalDetail: // Case baru
        return MaterialPageRoute(builder: (_) => const ApprovalDetailScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
