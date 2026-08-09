// lib/routes/shell_route_config.dart

import 'package:go_router/go_router.dart';
import 'app_shell_branches.dart';
import 'app_navigator.dart';

RouteBase buildAppShellRoute() {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      // Shell ini selalu membungkus tampilan dengan AppNavigator (BottomNavBar)
      return AppNavigator(navigationShell: navigationShell);
    },
    branches: appShellBranches,
  );
}