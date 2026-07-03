import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'widgets/app_navigation.dart';
import 'presentation/home_screens/home_screen.dart';
import 'presentation/cart_screens/cart_screen.dart';
import 'presentation/profile_screens/profile_screen.dart';
import 'presentation/order_screens/order_history_screen.dart';
import 'presentation/product_screens/product_detail_screen.dart';
import 'presentation/checkout_screens/checkout_screen.dart';
import 'presentation/auth_screens/login_screen.dart';
import 'providers/device_provider.dart';
import 'providers/session_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';

void main() {
  runApp(const MyApp());
}

// Konfigurasi GoRouter
final GoRouter _router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Menggunakan AppNavigation yang sudah Anda buat
        return AppNavigation(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp.router(
        title: 'MatrixSphere App',
        routerConfig: _router,
        theme: ThemeData(primarySwatch: Colors.teal),
      ),
    );
  }
}