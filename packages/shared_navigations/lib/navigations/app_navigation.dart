// app_navigation.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';

/// A helper class for navigating between screens.
/// This abstracts the GoRouter calls into more readable methods.
class AppNavigation {
  
  /// A more robust way to navigate to a specific tab in the BottomNavBar.
  /// It finds the GoRouter and uses `go` on the correct path.
  static void goToTab(BuildContext context, String route) {
    // Ensure the route is a valid main tab route
    final validTabs = [
      AppRoutes.caseOScreen,
      AppRoutes.case1Screen,
      AppRoutes.case2Screen,
      AppRoutes.case3Screen,
      AppRoutes.case4Screen
    ];
    if (validTabs.contains(route)) {
      final targetRoute = route == AppRoutes.caseOScreen ? AppRoutes.home : route;
      GoRouter.of(context).go(targetRoute);
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

  /// Navigates to the Streaming screen.
  /// This uses `go` which is suitable for top-level navigation.
  static void goToStream(BuildContext context) {
    context.go(AppRoutes.financial);
  }

  static void goToLogin(BuildContext context) {
    context.go(AppRoutes.login);
  }

  static void pushToLogin(BuildContext context) {
    context.push(AppRoutes.login);
  }

  static void goToForgotPassword(BuildContext context) {
    context.go(AppRoutes.forgotPassword);
  }

  static void pushToForgotPassword(BuildContext context) {
    context.push(AppRoutes.forgotPassword);
  }

  static void goToUserRegistration(BuildContext context) {
    context.go(AppRoutes.userRegistration);
  }

  static void pushToUserRegistration(BuildContext context) {
    context.push(AppRoutes.userRegistration);
  }

  static void goToShopRegistration(BuildContext context) {
    context.go(AppRoutes.shopRegistration);
  }

  static void pushToShopRegistration(BuildContext context) {
    context.push(AppRoutes.shopRegistration);
  }

  static void goToHome(BuildContext context) {
    context.go(AppRoutes.home);
  }


  /// Navigates to the Profile screen.
  /// This uses `push` to stack the screen on top of the current one.
  static void pushToUserProfile(BuildContext context) {
    context.push(AppRoutes.userProfile);
  }

  static void pushToShopProfile(BuildContext context) {
    context.push(AppRoutes.shopProfile);
  }

  static void pushToAnalytics(BuildContext context) {
    context.push(AppRoutes.analytics);
  }

  static void pushToApprovals(BuildContext context) {
    context.push(AppRoutes.approvals);
  }

  static void pushToAttendance(BuildContext context) {
    context.push(AppRoutes.attendance);
  }

  static void pushToAttendanceHistory(BuildContext context) {
    context.push(AppRoutes.attendanceHistory);
  }
  static void pushTosetting(BuildContext context) {
    context.push(AppRoutes.settings);
  }

  /// Navigates to the Edit Profile screen from the Profile screen.
  static void pushToEditProfile(BuildContext context) {
    context.push(AppRoutes.editprofile);
  }
  static void pushToSimulation(BuildContext context) {
    context.push(AppRoutes.simulation);
  }
  static void pushToSupport(BuildContext context) {
    context.push(AppRoutes.support);
  }
  static void pushToFeedBack(BuildContext context) {
    context.push(AppRoutes.feedback);
  }
  static void pushToFinancial(BuildContext context) {
    context.push(AppRoutes.financial);
  }
  static void pushToManagement(BuildContext context) {
    context.push(AppRoutes.management);
  }

  static void pushToMessages(BuildContext context) {
    context.push(AppRoutes.messages);
  }

  static void pushToNotifications(BuildContext context) {
    context.push(AppRoutes.notifications);
  }

  static void pushToTeam(BuildContext context) {
    context.push(AppRoutes.team);
  }

  static void pushToFiles(BuildContext context) {
    context.push(AppRoutes.files);
  }

  static void pushToTasks(BuildContext context) {
    context.push(AppRoutes.tasks);
  }

  static void pushToCalendar(BuildContext context) {
    context.push(AppRoutes.calendar);
  }

  static void pushToContacts(BuildContext context) {
    context.push(AppRoutes.contacts);
  }

  static void pushToReturns(BuildContext context) {
    context.push(AppRoutes.returns);
  }

  static void pushToVendors(BuildContext context) {
    context.push(AppRoutes.vendors);
  }

  static void pushToReviews(BuildContext context) {
    context.push(AppRoutes.reviews);
  }

  static void pushToMarketing(BuildContext context) {
    context.push(AppRoutes.marketing);
  }

  static void pushToSubscription(BuildContext context) {
    context.push(AppRoutes.subscription);
  }

  static void pushToBilling(BuildContext context) {
    context.push(AppRoutes.billing);
  }

  static void pushToApiKeys(BuildContext context) {
    context.push(AppRoutes.apiKeys);
  }

  static void pushToAuditLog(BuildContext context) {
    context.push(AppRoutes.auditLog);
  }

  static void pushToWebhooks(BuildContext context) {
    context.push(AppRoutes.webhooks);
  }

  static void pushToTemplates(BuildContext context) {
    context.push(AppRoutes.templates);
  }

  static void pushToAssets(BuildContext context) {
    context.push(AppRoutes.assets);
  }

  static void pushToUsers(BuildContext context) {
    context.push(AppRoutes.users);
  }

  static void pushToRoles(BuildContext context) {
    context.push(AppRoutes.roles);
  }

  static void pushToPermissions(BuildContext context) {
    context.push(AppRoutes.permissions);
  }


  static void goToShopRegister(BuildContext context) {
    context.go(AppRoutes.shopRegistration);
  }


  static void goToScanner(BuildContext context, {bool isAttendance = false}) {
    context.push('${AppRoutes.scanFace}?isAttendance=$isAttendance');
  }

  static void goToScannerProduct(BuildContext context) {
    context.push('${AppRoutes.scanQr}?isAttendance=false');
  }

  static void pushToScannerQr(BuildContext context) {
    context.push('${AppRoutes.scanQr}?isAttendance=false');
  }
  static void pushToScannerFace(BuildContext context) {
    context.push('${AppRoutes.scanFace}?isAttendance=true');
  }
  static void pushToScannerProduct(BuildContext context) {
    context.push('${AppRoutes.scanQr}?isAttendance=false');
  }
  static void pushToIntegration(BuildContext context) {
    context.push('${AppRoutes.Integrations}');
  }
}
