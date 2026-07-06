import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Ini adalah halaman placeholder. Anda bisa menggantinya dengan halaman utama
// aplikasi Anda yang sebenarnya.
class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}

/// Konfigurasi GoRouter untuk aplikasi.
final GoRouter appRouter = GoRouter(
  // Rute awal aplikasi.
  initialLocation: '/',
  // Aktifkan logging untuk membantu proses debug.
  debugLogDiagnostics: true,
  // Daftar rute aplikasi.
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PlaceholderHomeScreen(),
    ),
    // Tambahkan rute lain di sini sesuai kebutuhan.
  ],
);