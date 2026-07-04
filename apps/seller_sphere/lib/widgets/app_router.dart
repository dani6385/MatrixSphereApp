import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../presentation/home_screens/home_screen.dart';
import '../presentation/login_screens/login_screen.dart';
import '../presentation/login_screens/providers/auth_provider.dart';
import '../presentation/order_screens/order_list_screen.dart';
import '../presentation/order_screens/providers/order_detail_screen.dart';
import '../presentation/product_screens/models/add_product_screen.dart';
import '../presentation/product_screens/models/product_detail_screen.dart';
import '../presentation/product_screens/models/product_list_screen.dart';
import '../presentation/profile_screens/edit_profile_screen.dart';
import '../presentation/profile_screens/profile_screen.dart';
import '../presentation/settings_screens/providers/store_location_screen.dart';
import '../presentation/settings_screens/setting_screen.dart';
import '../utils/go_router_refresh_stream.dart';

// Provider tunggal untuk GoRouter
final goRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authProvider.notifier);

  return GoRouter(
    refreshListenable: GoRouterRefreshStream(authNotifier.stream),
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SellerHomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingScreen(),
        routes: [
          GoRoute(
            path: 'location', //  /settings/location
            builder: (context, state) => const StoreLocationScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
        routes: [
          GoRoute(
            path: 'edit', // /profile/edit
            builder: (context, state) => const EditProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductListScreen(),
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
        path: '/product/:productId',
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrderListScreen(),
        routes: [
          GoRoute(
            path: ':orderId', // /orders/order123
            builder: (context, state) {
              final orderId = state.pathParameters['orderId']!;
              return OrderDetailScreen(orderId: orderId);
            },
          ),
        ],
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
