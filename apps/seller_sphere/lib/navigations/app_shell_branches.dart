// lib/navigation/app_shell_branches.dart

//import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'custom_transition_page.dart';
import 'app_extractor.dart';
//import 'app_common_routes.dart'; // Mengimpor rute umum

// Kunci navigator untuk setiap cabang/tab.
// Ini penting agar navigasi ke halaman detail (seperti add/edit product)
// tetap berada di dalam tab yang sama dan tidak menutupi bottom nav bar.
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
        /*routes: [
          // Sub-rute dari Home
          GoRoute(
            path: 'products', // Path relatif: /products
            name: AppRoutes.publicProduct,
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
        ],*/
      ),
    ],
  ),

  // Branch untuk Tab Stream
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.financial,
        pageBuilder: (context, state) => FadeTransitionPage(
            child: const FinancialScreen()),
        routes: const [],
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
        /*routes: [
          // Sub-rute dari Home
          GoRoute(
            path: 'products', // Path relatif: /products
            name: AppRoutes.publicProduct,
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
        ],*/
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
        pageBuilder: (context, state) =>
            FadeTransitionPage(child: const AttendanceScreen()),
        routes: const [],
      ),
    ],
  ),
];
