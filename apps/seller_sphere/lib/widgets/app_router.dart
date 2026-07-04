import 'package:go_router/go_router.dart';
import 'package:seller_sphere/presentation/login_screens/login_screen.dart';
import 'package:seller_sphere/presentation/product_screens/product_list_screen.dart';
import 'package:seller_sphere/presentation/settings_screens/setting_screen.dart';
import 'package:seller_sphere/presentation/profile_screens/profile_screen.dart'; // Pastikan path ini benar
import 'package:seller_sphere/presentation/profile_screens/providers/edit_profile_screen.dart';
import 'package:seller_sphere/presentation/login_screens/providers/auth_provider.dart';

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    // Daftarkan authProvider agar GoRouter dapat mendengarkan perubahannya.
    refreshListenable: authProvider,
    initialLocation: '/',
    routes: [
      // Rute untuk halaman utama (Daftar Produk)
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductListScreen(),
      ),
      // Rute untuk halaman Pengaturan
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingScreen(),
      ),
      // Rute untuk halaman Profil
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'edit', // Ini akan menjadi sub-rute: /profile/edit
            builder: (context, state) => const EditProfileScreen(),
          ),
        ],
      ),
      // Rute untuk halaman Login
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    redirect: (context, state) {
      final isAuthenticated = authProvider.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      // Jika belum login dan tidak sedang di halaman login, arahkan ke /login.
      if (!isAuthenticated && !isLoggingIn) return '/login';
      // Jika sudah login dan mencoba mengakses halaman login, arahkan ke home.
      if (isAuthenticated && isLoggingIn) return '/';

      // Jika tidak ada kondisi di atas, jangan lakukan apa-apa.
      return null;
    },
  );
}