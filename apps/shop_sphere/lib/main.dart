import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'widgets/app_navigation.dart';
import 'presentation/home_screens/home_screen.dart';
//import 'providers/device_provider.dart';
//import 'providers/session_provider.dart';

void main() {
  runApp(const MyApp());
}

// Konfigurasi GoRouter
final GoRouter _router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Menggunakan AppNavigation yang sudah Anda buat
        return AppNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Tambahkan branch lain sesuai kebutuhan navbar Anda
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /*ChangeNotifierProvider(create: (_) => DeviceProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),*/
      ],
      child: MaterialApp.router(
        title: 'MatrixSphere App',
        routerConfig: _router,
        theme: ThemeData(primarySwatch: Colors.teal),
      ),
    );
  }
}