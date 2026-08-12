<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
// lib/routes/fullscreen_routes.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
<<<<<<< HEAD
import 'app_routes.dart';
=======
import 'package:seller_sphere/features/presentations/products/public_product_screen.dart';
//import 'app_routes.dart';
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
import 'app_extractor.dart';
// Impor layar-layar terkait (pastikan jalurnya sesuai project-mu)

List<RouteBase> buildFullscreenRoutes(
    GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    GoRoute(
<<<<<<< HEAD
      path: AppRoutes.profile,
=======
      path: '/map',
      builder: (context, state) => const WindowsMapView(),
    ),
    GoRoute(
      path: '/user-profile',
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const UserProfileScreen(),
    ),
    GoRoute(
<<<<<<< HEAD
      path: AppRoutes.profile,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ShopProfileScreen(shopId: '',),
    ),
    GoRoute(
      path: AppRoutes.order,
=======
      path: '/shop-profile',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ShopProfileScreen(),
    ),
    GoRoute(
      path: '/order',
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OrderScreen(),
    ),
    GoRoute(
<<<<<<< HEAD
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
=======
// lib/routes/fullscreen_routes.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'app_extractor.dart';
// Impor layar-layar terkait (pastikan jalurnya sesuai project-mu)

List<RouteBase> buildFullscreenRoutes(GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    GoRoute(
      path: AppRoutes.profile,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ProfileScreen(),
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
      path: '/products/:productId', // Menggunakan parameter dinamis ID
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['productId']!;
        return ProductDetailScreen(productId: id, shopId: '',);
      },
    ),
    GoRoute(
      path: '/products/edit/:productId', // Menggunakan parameter dinamis ID untuk edit
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['productId']!;
        return ProductFormScreen(productId: id);
      },
    ),
  ];
}
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======
      path: '/products',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const PublicProductScreen(),
    ),
    GoRoute(
      path: '/scan-qr',
      builder: (context, state) => const ScannerScreen(),
    ),
    GoRoute(
      path: '/simulasi',
      builder: (context, state) => const SimulationScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => const HelpScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/stream',
      builder: (context, state) => const StreamingScreen(streamId: '',),
    ),
  ];
}
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
