import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/home_screens/home_screen.dart';
import '../presentation/login_screens/login_screen.dart';
import '../presentation/login_screens/providers/auth_provider.dart';
import '../presentation/order_screens/order_list_screen.dart';
import '../presentation/order_screens/qr_scanner_screen.dart';
import '../presentation/order_screens/providers/order_detail_screen.dart';
import '../presentation/product_screens/models/add_product_screen.dart';
import '../presentation/product_screens/models/product_detail_screen.dart';
import '../presentation/product_screens/product_screen.dart';
import '../presentation/profile_screens/edit_profile_screen.dart';
import '../presentation/profile_screens/profile_screen.dart';
import '../presentation/setting_screens/providers/store_location_screen.dart';
import '../presentation/registration_screens/registration_screen.dart';
import '../presentation/setting_screens/setting_screen.dart';
import '../utils/go_router_refresh_stream.dart';
import '../widgets/app_navigation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(authNotifier.stream),
    initialLocation: '/',
    debugLogDiagnostics: true,

    routes: [
      // Rute Shell Utama dengan Navigasi Bawah
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppNavigation(navigationShell: navigationShell);
        },
        branches: [
          // Cabang 1: HOME
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/', 
                builder: (context, state) => const SellerHomeScreen(),
              ),
            ],
          ),

          // Cabang 2: PRODUK (dengan sub-rute)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/products',
                builder: (context, state) => const ProductScreen(),
                routes: [
                  GoRoute(
                    path: 'detail/:productId', //  /products/detail/123
                    builder: (context, state) => ProductDetailScreen(productId: state.pathParameters['productId']!),
                  ),
                ]
              ),
            ],
          ),

          // Cabang 3: TRANSAKSI (dengan sub-rute)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/orders',
                builder: (context, state) => const OrderListScreen(),
                routes: [
                  GoRoute(
                    path: ':orderId', // /orders/abc
                    builder: (context, state) =>
                        OrderDetailScreen(orderId: state.pathParameters['orderId']!),
                    routes: [
                      GoRoute(
                          path: 'verify', builder: (context, state) => const QrScannerScreen()),
                    ],
                  ),
                ]
              ),
            ],
          ),

          // Cabang 4: AKUN (dengan sub-rute)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                 routes: [
                  GoRoute(
                    path: 'edit', // /profile/edit
                    builder: (context, state) => const EditProfileScreen(),
                  ),
                ]
              ),
            ],
          ),
        ],
      ),

      // Rute level atas (tanpa BottomNav)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
       GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: '/add-product',
        builder: (context, state) => const AddProductScreen(),
      ),
       GoRoute(
          path: '/edit-product/:productId',
          builder: (context, state) {
            final productId = state.pathParameters['productId']!;
            return AddProductScreen(productId: productId);
          },
        ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingScreen(),
        routes: [
           GoRoute(
            path: 'location',
            builder: (context, state) => const StoreLocationScreen(),
          ),
        ]
      ),
    ],

    redirect: (context, state) {
      final isAuthenticated = authNotifier.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }
      if (isAuthenticated && isLoggingIn) {
        return '/';
      }
      return null;
    },
  );
});
