
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shared_services/shared_servic.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      
    ),
    GoRoute(
      path:'/onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingPage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final authState = context.read<AuthBloc>().state;
    final bool loggedIn = authState is AuthAuthenticated;
    final bool loggingIn = state.matchedLocation == '/login';
    final bool onOnboarding = state.matchedLocation == '/onboarding';
    final bool onSplash = state.matchedLocation == '/';

    // If not logged in, and not on login or onboarding page, redirect to login
    if (!loggedIn && !loggingIn && !onOnboarding && !onSplash) {
      return '/login';
    }
    // If logged in, and trying to go to login or onboarding, redirect to home
    if (loggedIn && (loggingIn || onOnboarding || onSplash)) {
      return '/home';
    }
    // No redirect needed
    return null;
  },
  refreshListenable: GoRouterRefreshStream(AuthBloc(authService: context.read())), // This line needs to be fixed. AuthBloc should be provided via BlocProvider.
);

// Helper class to convert a Stream into a Listenable for GoRouter's refreshListenable
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}