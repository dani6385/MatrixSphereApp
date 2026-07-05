import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widget/app_navigation.dart';
import 'presentation/home_screen/home_screen.dart';
import 'presentation/registration_screens/list/seller_registration_list_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppNavigation(navigationShell: navigationShell);
      },
      branches: [
        // Branch untuk tab Home
        StatefulShellBranch(routes: [
          GoRoute(path: '/home', builder: (context, state) => const MyHomePage(title: 'MatrixSphere')),
        ]),
        // Branch untuk tab Registration
        StatefulShellBranch(routes: [
          GoRoute(path: '/registration', builder: (context, state) => const SellerRegistrationListScreen()),
        ]),
        // Branch untuk tab Detail Status
        StatefulShellBranch(routes: [
          GoRoute(path: '/status', builder: (context, state) => const Center(child: Text('Detail Status Screen'))),
        ]),
        // Branch untuk tab Akun
        StatefulShellBranch(routes: [
          GoRoute(path: '/account', builder: (context, state) => const Center(child: Text('Account Screen'))),
        ]),
        // Branch untuk tab Settings
        StatefulShellBranch(routes: [
          GoRoute(path: '/settings', builder: (context, state) => const Center(child: Text('Settings Screen'))),
        ]),
      ],
    ),
  ],
);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MatrixSphere',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
