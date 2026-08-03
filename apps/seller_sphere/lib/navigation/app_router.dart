// lib/navigation/app_router.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_navigator.dart';
import 'app_shell_branches.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seller_sphere/navigation/app_routes.dart';

import 'app_extractor.dart';

// Ini adalah kelas helper untuk GoRouter agar bisa mendengarkan Stream
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// Buat key untuk root navigator
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.login, // Atau halaman splash screen jika ada
  navigatorKey: rootNavigatorKey,
  redirect: (BuildContext context, GoRouterState state) {
    // Periksa status login dari Firebase Auth
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

    // Dapatkan lokasi yang sedang dituju
    final String location = state.uri.toString();

    // Daftar halaman publik yang bisa diakses tanpa login
    final bool isPublicPage = location == AppRoutes.login ||
        location == AppRoutes.register ||
        location ==
            AppRoutes.forgotPassword; // Sesuaikan dengan rute publik Anda

    // Skenario:
    // 1. Jika pengguna BELUM login dan TIDAK sedang menuju halaman publik,
    //    maka alihkan (redirect) ke halaman login.
    if (!isLoggedIn && !isPublicPage) {
      return AppRoutes.login;
    }

    // 2. Jika pengguna SUDAH login dan sedang mencoba mengakses halaman publik,
    //    maka alihkan ke halaman utama (home).
    if (isLoggedIn && isPublicPage) {
      return AppRoutes.home;
    }

    // 3. Jika tidak ada kondisi di atas yang terpenuhi, jangan lakukan redirect.
    return null;
  },
  // Ini adalah bagian KRUSIAL untuk persistensi sesi dengan GoRouter
  refreshListenable:
      GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
  routes: <RouteBase>[
    // StatefulShellRoute untuk halaman utama dengan Bottom Navigation Bar.
    StatefulShellRoute.indexedStack(
      // Rute-rute di dalam 'branches' akan ditampilkan di dalam AppNavigator
      builder: (context, state, navigationShell) {
        return AppNavigator(navigationShell: navigationShell);
      },
      branches: appShellBranches,
    ),

    // Rute-rute di luar Shell (misalnya, halaman login, register, dll.)
    // Ini penting agar redirect berfungsi dengan benar.
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) =>
          const HomeScreen(), // Ganti dengan halaman utama Anda
    ),
    GoRoute(
      path: AppRoutes.shopRegistration,
      builder: (context, state) => const ShopRegistrationScreen(),
    ),

    GoRoute(
      path: AppRoutes.productDetail,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final String productId = state.pathParameters['id']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: AppRoutes
          .productDetailEdit, // Menggunakan '/products/:productId/edit'
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        state.pathParameters['productId']!;
        return const AddProductScreen();
      },
    ),
    GoRoute(
      path: AppRoutes.chat,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: AppRoutes.attendance,
      builder: (context, state) => const AttendanceScreen(),
    ),
    GoRoute(
      path: AppRoutes.management,
      builder: (context, state) => const ManagementScreen(),
      routes: [
        GoRoute(
          path: AppRoutes.publicProduct,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const PublicProductScreen(),
          routes: [
            GoRoute(
              path: AppRoutes.addProduct,
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const AddProductScreen(),
            ),
            GoRoute(
              path: AppRoutes.productDetail,
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const ProductDetailScreen(
                productId: '',
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.sellers,
      builder: (context, state) => const SellerScreen(),
      routes: [
        GoRoute(
          path: AppRoutes.status,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const PublicProductScreen(),
          routes: [
            GoRoute(
              path: AppRoutes.addProduct,
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const AddProductScreen(),
            ),
            GoRoute(
              path: AppRoutes.productDetail,
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const ProductDetailScreen(
                productId: '',
              ),
            ),
          ],
        ),
        GoRoute(
          path: AppRoutes.profile,
          parentNavigatorKey: rootNavigatorKey,
          builder: (context, state) => const ProfileScreen(),
          routes: [
            GoRoute(
              path: AppRoutes.editProfile,
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.stream,
      builder: (context, state) => const StreamingScreen(
        streamId: '',
      ),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
      parentNavigatorKey: rootNavigatorKey,
    ),
  ],
);

extension GoRouterExtension on GoRouter {
  String get location {
    return routerDelegate.currentConfiguration.uri.toString();
  }
}
