// lib/routes/fullscreen_routes.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'app_extractor.dart';
// Impor layar-layar terkait (pastikan jalurnya sesuai project-mu)

List<RouteBase> buildFullscreenRoutes(
    GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    GoRoute(
      path: AppRoutes.profile,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const UserProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ShopProfileScreen(shopId: '',),
    ),
    GoRoute(
      path: AppRoutes.order,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OrderScreen(),
    ),
    GoRoute(
      path: AppRoutes.addProduct,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ProductFormScreen(),
    ),
    GoRoute(
      path: AppRoutes.scanQr,
      builder: (context, state) => const ScannerScreen(),
    ),
    GoRoute(
      path: AppRoutes.simulation,
      builder: (context, state) => const SimulationScreen(),
    ),
    GoRoute(
      path: '/products/:productId', // Menggunakan parameter dinamis ID
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['productId']!;
        return ProductDetailScreen(
          productId: id,
          shopId: '',
        );
      },
    ),
    GoRoute(
      path:
          '/products/edit/:productId', // Menggunakan parameter dinamis ID untuk edit
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['productId']!;
        return ProductFormScreen(productId: id);
      },
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) {
        const activeShopId = 'toko_agan';

        return const OrderListView(shopId: activeShopId,);
      },
    ),
  ];
}
