import 'package:go_router/go_router.dart';
import 'package:shop_sphere/presentation/setting_screens/widgets/add_edit_address_screen.dart';
import 'package:shop_sphere/presentation/setting_screens/settings_screen.dart';
import 'package:shop_sphere/providers/session_provider.dart';
import '../../presentation/auth_screens/login_screen.dart';
import '../../presentation/cart_screens/cart_screen.dart';
import '../../presentation/checkout_screens/checkout_screen.dart';
import '../../presentation/home_screens/home_screen.dart';
import '../../presentation/order_screens/order_history_screen.dart';
import '../../presentation/order_screens/order_success_screen.dart';
import '../../presentation/product_screens/models/product_detail_screen.dart';
import '../../presentation/profile_screens/profile_screen.dart';
import '../../widgets/app_navigation.dart';
import 'custom_page_transitions.dart';

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
      pageBuilder: (context, state) => SlideTransitionPage(
        key: state.pageKey,
        direction: SlideDirection.bottom, // Muncul dari bawah
        child: const OrderHistoryScreen(),
      ),
    ),
    GoRoute(
      path: '/order-success/:orderId',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        // Asumsi Anda sudah memiliki OrderSuccessScreen dari respons sebelumnya
        return OrderSuccessScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/settings/:title',
      pageBuilder: (context, state) {
        final title = state.pathParameters['title'] ?? 'Pengaturan';
        return SlideTransitionPage(
          // Tidak perlu menentukan arah, akan menggunakan default (kanan)
          key: state.pageKey,
          child: SettingsScreen(title: title),
        );
      },
    ),
    GoRoute(
      path: '/add-address',
      pageBuilder: (context, state) => SlideTransitionPage(
        key: state.pageKey,
        direction: SlideDirection.bottom, // Muncul dari bawah seperti modal
        child: const AddEditAddressScreen(),
      ),
    ),
    GoRoute(
      path: '/edit-address',
      pageBuilder: (context, state) {
        // Ambil objek AddressModel dari parameter 'extra'
        final address = state.extra as AddressModel?;
        return SlideTransitionPage(
          key: state.pageKey,
          direction: SlideDirection.bottom,
          child: AddEditAddressScreen(address: address),
        );
      },
    ),
  ],
);