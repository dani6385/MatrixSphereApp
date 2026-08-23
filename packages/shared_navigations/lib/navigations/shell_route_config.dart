// Di dalam packages/shared_navigation/lib/routes/shell_route_config.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

RouteBase buildAppShellRoute({
  required Widget Function(BuildContext, GoRouterState, StatefulNavigationShell) shellBuilder,
  required List<StatefulShellBranch> branches,
}) {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      // Kita menggunakan shellBuilder agar aplikasi bisa menentukan 
      // BottomNavBar-nya sendiri secara dinamis
      return shellBuilder(context, state, navigationShell);
    },
    branches: branches,
  );
}