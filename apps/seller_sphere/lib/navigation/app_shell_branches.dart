// lib/navigation/app_shell_branches.dart

//import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:seller_sphere/navigation/custom_transition_page.dart';
import 'app_extractor.dart';
import 'app_common_routes.dart'; // Mengimpor rute umum


// Kunci navigator untuk setiap cabang/tab.
// Ini penting agar navigasi ke halaman detail (seperti add/edit product)
// tetap berada di dalam tab yang sama dan tidak menutupi bottom nav bar.
// Letakkan ini di bagian paling atas file (di luar kurung kurawal class/function)
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorHomeKey =
    GlobalKey<NavigatorState>(debugLabel: 'ShellHome');

/// Daftar cabang untuk [StatefulShellRoute].
/// Setiap [StatefulShellBranch] mewakili satu tab pada bottom navigation bar.
final List<StatefulShellBranch> appShellBranches = [
  // Branch untuk Tab Home
  StatefulShellBranch(
    navigatorKey:
        _shellNavigatorHomeKey, // Gunakan navigator key untuk branch ini
    routes: [
      GoRoute(
        path: '/',
        name: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
        routes: [
          // Sub-rute dari Home
          GoRoute(
            path: 'products', // Path relatif: /products
            name: AppRoutes.product,
            builder: (context, state) => const PublicProductScreen(),
            routes: [
              // Rute ini sekarang akan menggunakan navigator dari branch Home
              GoRoute(
                path: 'add', // Path relatif: /products/add
                name: AppRoutes.addProduct,
                builder: (context, state) => const AddProductScreen(),
              ),
              GoRoute(
                path: 'edit', // Path relatif: /products/edit
                name: AppRoutes.editProduct,
                builder: (context, state) => const AddProductScreen(),
              ),
            ],
          ),
        ],
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
        routes: commonDetailRoutes,
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
        routes: [
          // Sub-rute dari Home
          GoRoute(
            path: 'products',
            name: AppRoutes.product,
            builder: (context, state) => const PublicProductScreen(),
            routes: [
              // Sub-rute ini otomatis menjadi full screen dan menyembunyikan Bottom Navigation Bar
              GoRoute(
                path: 'add',
                name: AppRoutes.addProduct,
                parentNavigatorKey: rootNavigatorKey, // <-- KUNCI UTAMA DI SINI
                builder: (context, state) => const AddProductScreen(),
              ),
              GoRoute(
                path: 'detail/:productId/:shopId',
                name: AppRoutes.productDetail,
                parentNavigatorKey: rootNavigatorKey, // <-- KUNCI UTAMA DI SINI
                builder: (context, state) {
                  final productId = state.pathParameters['productId']!;
                  final shopId = state.pathParameters['shopId']!;
                  return ProductDetailScreen(
                      productId: productId, shopId: shopId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),

  // Branch untuk Tab Sellers (Products)
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.sellers,
        pageBuilder: (context, state) =>
            FadeTransitionPage(child: const SellerScreen()),
        //routes: commonDetailRoutes,
      ),
    ],
  ),

  // Branch untuk Tab Attendance
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.attendance,
        pageBuilder: (context, state) => FadeTransitionPage(
            child: AttendanceScreen(
          // Placeholder values for AttendanceScreen
          isScanning: false, // Placeholder
          hasCameraPermission: false, // Placeholder
          cameraController: null, // Placeholder
          laserAnimation: const AlwaysStoppedAnimation(0.0), // Placeholder
          scanStatusMessage: '', // Placeholder
          scanProgress: 0.0, // Placeholder
          onCancelScan: () {}, // Placeholder
          onRequestPermission: () {}, // Placeholder
          isCheckingLocation: false, // Placeholder (was null, now bool)
          onClockIn: () {},
          onClockOut: () {},
          attendanceHistory: const [],
          onSync: () {},
        )),
        routes: commonDetailRoutes,
      ),
    ],
  ),
];
