// app_navigation.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

/// A helper class for navigating between screens.
/// This abstracts the GoRouter calls into more readable methods.
class AppNavigation {
  /// Navigates to the Streaming screen.
  static void goToStream(BuildContext context) {
    context.go(AppRoutes.stream);
  }

  /// Goes back to the previous screen in the navigation stack.
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }
}