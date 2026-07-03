import 'package:go_router/go_router.dart';
import 'package:shop_sphere/presentation/home_screens/home_screen.dart';

/// Centralized navigation configuration for the application.
class AppNavigation {
  // Private constructor to prevent instantiation.
  AppNavigation._();

  /// The main router for the application.
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true, // Set to false in production
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}