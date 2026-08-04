import 'package:go_router/go_router.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/ui/splash_screen.dart';

import 'app_extractor.dart';
import 'app_routes.dart';

/// Manages application routing and navigation using GoRouter.
class AppRouter {
  AppRouter._();

  static late GoRouter router;

  /// Initializes the router with authentication logic.
  static void initialize(AuthBloc authBloc) {
    router = GoRouter(
      // Listen to authentication state changes for redirection.
      refreshListenable: GoRouterRefreshStream(authBloc.stream),

      // The initial route to be displayed when the app starts.
      initialLocation: splashRoute,

      // The list of all available routes in the app.
      routes: <GoRoute>[
        GoRoute(
          path: splashRoute,
          name: splashRoute,
          builder: (context, state) => const SplashScreen(),
        ),
        /*GoRoute(
          path: loginRoute,
          name: loginRoute,
          builder: (context, state) => const LoginScreen(),
        ),*/
        GoRoute(
          path: homeRoute,
          name: homeRoute,
          builder: (context, state) => const HomeScreen(),
        ),
        // Tambahkan rute lain di sini jika diperlukan
      ],

      // Redirect logic based on authentication status.
      /*redirect: (BuildContext context, GoRouterState state) {
        final authStatus = authBloc.state.status;
        final isLoggingIn = state.matchedLocation == loginRoute;

        // If the user is authenticated but on the login page, redirect to home.
        if (authStatus == AuthStatus.authenticated && isLoggingIn) {
          return homeRoute;
        }

        // If the user is not authenticated and not on the login page, redirect to login.
        if (authStatus == AuthStatus.unauthenticated && !isLoggingIn) {
          return loginRoute;
        }

        // No redirect needed.
        return null;
      },*/
    );
  }
}
