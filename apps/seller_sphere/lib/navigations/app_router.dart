
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:go_router/go_router.dart';
import 'app_extractor.dart';


class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutePaths.rootPath,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutePaths.rootPath,
        name: AppRoutes.rootRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const Text('Root Page'); // Placeholder for the root page
        },
      ),
      GoRoute(
        path: AppRoutePaths.loginPath,
        name: AppRoutes.loginRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const Text('Login Page'); // Placeholder for the login page
        },
      ),
      GoRoute(
        path: AppRoutePaths.homePath,
        name: AppRoutes.homeRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const Text('Home Page'); // Placeholder for the home page
        },
      ),
      GoRoute(
        path: AppRoutePaths.splashPath,
        name: AppRoutes.splashRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const Text('Splash Page'); // Placeholder for the splash page
        },
      ),
      GoRoute(
        path: AppRoutePaths.onboardingPath,
        name: AppRoutes.onboardingRouteName,
        builder: (BuildContext context, GoRouterState state) {
          return const Text(
              'Onboarding Page'); // Placeholder for the onboarding page
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      // Example redirect logic:
      // If the user is not authenticated and tries to access a protected route,
      // redirect them to the login page.
      // For now, we'll keep it simple.
      final bool loggedIn =
          AuthService().isLoggedIn(); // Assuming AuthService provides this
      final bool goingToLogin =
          state.matchedLocation == AppRoutePaths.loginPath;

      if (!loggedIn && !goingToLogin) {
        return AppRoutePaths.loginPath;
      }
      return null; // No redirect needed
    },
  );
}

