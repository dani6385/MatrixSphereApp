import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_extraktor.dart';
import 'package:seller_sphere/navigation/app_navigator.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:seller_sphere/navigation/custom_transition_page.dart';
import 'package:shared_services/shared_services.dart';

/// Kunci navigator global untuk rute root.
/// Digunakan untuk navigasi yang perlu "keluar" dari shell,
/// seperti navigasi ke halaman login dari dalam tab.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Konfigurasi GoRouter untuk aplikasi Seller Sphere.
///
/// Menggunakan [StatefulShellRoute] untuk mempertahankan state pada setiap tab
/// dari bottom navigation bar.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    // Rute untuk halaman yang tidak menggunakan Shell (BottomNavBar),
    // seperti halaman login.
    /*GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),*/

    // StatefulShellRoute untuk halaman utama dengan Bottom Navigation Bar.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Widget AppNavigator bertindak sebagai UI shell (Scaffold, Drawer, BottomNavBar).
        return AppNavigator(navigationShell: navigationShell);
      },
      branches: appShellBranches,
    ),
  ],
);

/// Daftar cabang untuk [StatefulShellRoute].
/// Setiap [StatefulShellBranch] mewakili satu tab pada bottom navigation bar.
final List<StatefulShellBranch> appShellBranches = [
  // Branch untuk Tab Home
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) =>
            FadeTransitionPage(child: const HomeScreen()),
        routes: _commonDetailRoutes, // Rute detail yang bisa diakses dari Home
      ),
    ],
  ),

  // Branch untuk Tab Stream
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.stream,
        pageBuilder: (context, state) => FadeTransitionPage(
            child: const StreamingScreen(
          streamId: '',
        )),
        routes: _commonDetailRoutes,
      ),
    ],
  ),

  // Branch untuk Tab Management
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.management,
        pageBuilder: (context, state) =>
            FadeTransitionPage(child: const ManagementScreen()),
        routes: _commonDetailRoutes,
      ),
    ],
  ),

  // Branch untuk Tab Sellers (Products)
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.sellers,
        // Menggunakan 'sellers' sebagai path utama tab
        pageBuilder: (context, state) => FadeTransitionPage(
            child: ProductScreen(
          shopUid: '',
          // The named parameter 'product' is required, but there's no corresponding argument.
          // Adding a dummy Product object to satisfy the constructor.
          // This might indicate a design issue if ProductScreen is intended to be a list view.
          product: Product(
            id: 'dummy_id', // Placeholder ID
            name: 'Dummy Product', // Placeholder name
            price: 0.0, // Placeholder price
            stock: 0, // Placeholder stock
            description: '', // Placeholder description
            imageUrl: '', // Placeholder image URL
            shopId: '',
            sellingPrice: 0.0,
            purchasePrice: 0.0,
          ),
        )),
        routes: [
          // Sub-route untuk detail produk
          GoRoute(
            path: ':productId', // Path relatif: /sellers/:productId
            builder: (context, state) => ProductDetailScreen(
              productId: state.pathParameters['productId']!,
            ),
          ),
        ],
      ),
    ],
  ),

  // Branch untuk Tab Attendance
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.attendance,
        pageBuilder: (context, state) =>
            FadeTransitionPage(child: const AttendanceScreen()),
        routes: _commonDetailRoutes,
      ),
    ],
  ),
];

/// Daftar rute umum yang dapat diakses dari berbagai tab.
/// Rute ini akan ditampilkan di atas Shell (tanpa BottomNavBar).
final List<RouteBase> _commonDetailRoutes = [
  /*GoRoute(
    path: AppRoutes.profile.substring(1), // Hapus '/' di awal
    parentNavigatorKey: _rootNavigatorKey, // Tampilkan di atas shell
    builder: (context, state) => const ProfileScreen(),
    routes: [
      GoRoute(
        path: AppRoutes.editprofile.split('/').last, // Hanya 'edit'
        builder: (context, state) => const EditProfileScreen(),
      ),
    ],
  ),*/
  GoRoute(
    path: AppRoutes.settings.substring(1),
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) => const SettingScreen(),
  ),
  GoRoute(
    path: AppRoutes.chat.substring(1),
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) => const ChatScreen(),
  ),
  GoRoute(
    path: 'products/:productId', // Contoh rute detail dari tab lain
    parentNavigatorKey: _rootNavigatorKey,
    builder: (context, state) => ProductDetailScreen(
      productId: state.pathParameters['productId']!,
    ),
  ),
];
