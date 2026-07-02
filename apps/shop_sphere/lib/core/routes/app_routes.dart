import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere/navigation/shop_app_navigation.dart';
import '../../presentation/home_screen/home_screen.dart';
import '../../presentation/login_screen/login_screen.dart';

// Gunakan instance dari navigasi untuk mendapatkan path.
final ShopAppNavigation _nav = ShopAppNavigation();

final GoRouter appRouter = GoRouter(
  // Arahkan rute awal ke home screen dari ShopAppNavigation
  initialLocation: _nav.homeScreen,
  routes: [
    // Rute utama untuk home screen
    GoRoute(
      path: _nav.homeScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    ),

    // Rute untuk login screen
    GoRoute(
      path: _nav.loginScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    ),
  ],
   // Redirect rute root '/' ke home screen yang sebenarnya.
  redirect: (context, state) {
    if (state.matchedLocation == '/') {
      return _nav.homeScreen;
    }
    return null;
  },
);
