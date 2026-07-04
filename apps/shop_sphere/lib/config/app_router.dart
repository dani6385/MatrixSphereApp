import 'package:go_router/go_router.dart';
import '../../presentation/auth_screens/login_screen.dart';
import '../../presentation/cart_screens/cart_screen.dart';
import '../../presentation/checkout_screens/checkout_screen.dart';
import '../../presentation/home_screens/home_screen.dart';
import '../../presentation/order_screens/order_history_screen.dart';
import '../../presentation/product_screens/models/product_detail_screen.dart';
import '../../presentation/profile_screens/profile_screen.dart';
import '../../widgets/app_navigation.dart';

/// Konfigurasi GoRouter untuk aplikasi.
///
/// Variabel ini diekspos agar dapat diakses dari `main.dart`.
final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    // Rute utama dengan navigasi shell (BottomNavigationBar)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Widget shell yang membungkus cabang-cabang navigasi.
        return AppNavigation(navigationShell: navigationShell);
      },
      branches: [
        // Cabang untuk tab "Home"
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Cabang untuk tab "Cart"
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
        // Cabang untuk tab "Profile"
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    // Rute-rute lain yang tidak termasuk dalam navigasi shell
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/product/:productId',
      builder: (context, state) {
        final productId = state.pathParameters['productId']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrderHistoryScreen(),
    ),
  ],
);