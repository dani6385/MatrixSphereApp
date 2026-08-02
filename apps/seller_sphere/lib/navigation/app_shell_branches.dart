// lib/navigation/app_shell_branches.dart

//import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:seller_sphere/navigation/custom_transition_page.dart';
import 'app_extraktor.dart';
import 'app_common_routes.dart'; // Mengimpor rute umum

/// Daftar cabang untuk [StatefulShellRoute].
/// Setiap [StatefulShellBranch] mewakili satu tab pada bottom navigation bar.
final List<StatefulShellBranch> appShellBranches = [
  // Branch untuk Tab Home
  StatefulShellBranch(
    routes: [
        GoRoute(
          path: '/',
          name: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
          routes: [
            // Sub-rute dari Home
            GoRoute(
              path: 'products', // Path relatif: /products
              name: AppRoutes.products,
              builder: (context, state) => const PublicProductScreen(),
              routes: [
                GoRoute(
                  path: 'add', // Path relatif: /products/add
                  name: AppRoutes.addProduct,
                  builder: (context, state) => const AddProductScreen(),
                ),
                GoRoute(
                  path: 'edit', // Path relatif: /products/add
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
        routes: commonDetailRoutes, // Gunakan rute umum jika diperlukan
      ),
      ],

  ),

  // Branch untuk Tab Sellers (Products)
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.sellers,
        pageBuilder: (context, state) => FadeTransitionPage(
            child: const SellerScreen()),
        routes: commonDetailRoutes,
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
        routes: commonDetailRoutes,
      ),
    ],
  ),
];