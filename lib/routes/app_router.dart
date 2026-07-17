import 'package:flutter/material.dart';

import '../screens/home/home_screen.dart';
import '../screens/approval/approval_screen.dart';
import '../screens/attendance/attendance_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.approval:
        return MaterialPageRoute(builder: (_) => const ApprovalScreen());
      case AppRoutes.attendance:
        return MaterialPageRoute(builder: (_) => const AttendanceScreen());
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
