import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/main_shell.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// Konfigurasi GoRouter
final GoRouter _router = GoRouter(
  initialLocation: '/dasbor',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // MainShell membungkus semua halaman dan menyediakan UI konsisten (AppBar, BottomNav)
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/dasbor',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/barang',
          builder: (context, state) => const InventoryScreen(),
        ),
        GoRoute(
          path: '/kasir',
          builder: (context, state) => const TransactionScreen(),
        ),
        GoRoute(
          path: '/label',
          builder: (context, state) => const LabelPrinterScreen(),
        ),
        GoRoute(
          path: '/laporan',
          builder: (context, state) => const LaporanSyncCombinedTabScreen(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Seller Sphere',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: slateDarkBackground,
        colorScheme: const ColorScheme.dark(
          surface: slateDarkCard,
          onSurface: Colors.white,
          primary: neonCyan,
          onPrimary: slateDarkBackground,
          secondary: warmOrange,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
