import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_sphere/navigation/shop_app_navigation.dart';
import 'package:shop_sphere/presentation/account_screen/account_screen.dart';
import 'package:shop_sphere/presentation/home_screen/home_screen.dart';
import 'package:shop_sphere/presentation/login_screen/login_screen.dart';
import 'package:shop_sphere/widgets/placeholder_screen.dart';
import 'package:shop_sphere/widgets/scaffold_with_nav_bar.dart';

// Kunci Global untuk ShellRoute agar dapat diakses oleh rute lain
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Instance navigasi untuk path rute
final ShopAppNavigation _nav = ShopAppNavigation();

final GoRouter appRouter = GoRouter(
  initialLocation: _nav.homeScreen, 
  navigatorKey: _rootNavigatorKey,
  routes: [
    // StatefulShellRoute untuk navigasi utama dengan BottomNavBar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Gunakan ScaffoldWithNavBar sebagai UI shell
        return ScaffoldWithNavBar(child: navigationShell);
      },
      branches: [
        // Cabang 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: _nav.homeScreen,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: HomeScreen(),
              ),
            ),
          ],
        ),

        // Cabang 2: Status
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: _nav.statusScreen,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PlaceholderScreen(title: 'Status'),
              ),
            ),
          ],
        ),

        // Cabang 3: Transaksi
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/shop/transactions', // Ganti dengan _nav nanti
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PlaceholderScreen(title: 'Transaksi'),
              ),
            ),
          ],
        ),

        // Cabang 4: Akun
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/shop/account', // Ganti dengan _nav nanti
              pageBuilder: (context, state) => const NoTransitionPage(
                child: AccountScreen(),
              ),
            ),
          ],
        ),

        // Cabang 5: Settings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/shop/settings', // Ganti dengan _nav nanti
              pageBuilder: (context, state) => const NoTransitionPage(
                child: PlaceholderScreen(title: 'Settings'),
              ),
            ),
          ],
        ),
      ],
    ),

    // Rute di luar Shell (ditampilkan sebagai layar penuh tanpa NavBar)
    GoRoute(
      path: _nav.loginScreen,
      parentNavigatorKey: _rootNavigatorKey, // Tampilkan di navigator root
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
);
