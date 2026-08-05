// app_navigation.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

/// A helper class for navigating between screens.
/// This abstracts the GoRouter calls into more readable methods.
class AppNavigation {
  /// Navigates to the Streaming screen.
  /// This uses `go` which is suitable for top-level navigation.
  static void goToStream(BuildContext context) {
    context.go(AppRoutes.stream);
  }

  
  //static void goToLogin(BuildContext context) {
    //context.go(AppRoutes.login);
  //}

  /// Navigates to the Profile screen.
  /// This uses `push` to stack the screen on top of the current one.
  /*static void pushToProfile(BuildContext context) {
    context.push(AppRoutes.profile);
  }*/
  static void pushTosetting(BuildContext context) {
    context.push(AppRoutes.settings);
  }

  /// Navigates to the Edit Profile screen from the Profile screen.
  /*static void pushToEditProfile(BuildContext context) {
    context.push(AppRoutes.editprofile);
  }*/

  /// A more robust way to navigate to a specific tab in the BottomNavBar.
  /// It finds the GoRouter and uses `go` on the correct path.
  static void goToTab(BuildContext context, String route) {
    // Ensure the route is a valid main tab route
    final validTabs = [
      AppRoutes.home,
      AppRoutes.stream,
      AppRoutes.management,
      AppRoutes.sellers,
      AppRoutes.attendance
    ];
    if (validTabs.contains(route)) {
      GoRouter.of(context).go(route);
    } else {
      // Log an error in debug mode if a non-tab route is passed
      debugPrint(
          'Error: Attempted to navigate to a non-tab route "$route" using goToTab.');
    }
  }

  /// Goes back to the previous screen in the navigation stack.
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }
}
