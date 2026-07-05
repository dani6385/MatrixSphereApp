import 'package:go_router/go_router.dart';
import 'package:matrix_sphere_app/presentation/aprops/register_seller_screen.dart';
import 'package:matrix_sphere_app/presentation/home_screen/home_screen.dart';
import 'package:matrix_sphere_app/presentation/registration_screens/list/seller_registration_list_screen.dart';

/// Konfigurasi GoRouter untuk aplikasi.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Rute untuk halaman utama
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),

    // Rute untuk halaman formulir pendaftaran mitra
    GoRoute(
      path: '/register-seller',
      builder: (context, state) => const RegisterSellerScreen(),
    ),

    // Rute untuk halaman daftar pendaftaran mitra (untuk admin)
    GoRoute(
      path: '/seller-registrations',
      builder: (context, state) => const SellerRegistrationListScreen(),
    ),
  ],
);