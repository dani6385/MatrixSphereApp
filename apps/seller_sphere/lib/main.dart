import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';
import 'presentation/home_screens/home_screen.dart';
import 'presentation/product_screens/add_product_screen.dart';
import 'presentation/order_screens/order_list_screen.dart';
import 'presentation/settings_screens/providers/store_location_screen.dart';
import 'presentation/product_screens/product_list_screen.dart';
import 'presentation/order_screens/providers/order_detail_screen.dart';
import 'presentation/product_screens/providers/product_provider.dart';
import 'presentation/order_screens/providers/order_provider.dart';
import 'presentation/profile_screens/providers/seller_profile_provider.dart';

void main() {
  runApp(const SellerApp());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SellerHomeScreen(),
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
      path: '/products',
      builder: (context, state) => const ProductListScreen(),
    ),
    GoRoute(
      path: '/settings/location',
      builder: (context, state) => const StoreLocationScreen(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrderListScreen(),
      routes: [
        GoRoute(
          path: ':orderId', // e.g., /orders/order1
          builder: (context, state) {
            final orderId = state.pathParameters['orderId']!;
            return OrderDetailScreen(orderId: orderId);
          },
        ),
      ],
    ),
  ],
);

class SellerApp extends StatelessWidget {
  const SellerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OrderProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => SellerProfileProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Seller Sphere',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
        ),
      ),
    );
  }
}
