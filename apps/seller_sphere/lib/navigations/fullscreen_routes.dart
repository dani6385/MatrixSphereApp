// lib/routes/fullscreen_routes.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/features/presentations/products/public_product_screen.dart';
//import 'app_routes.dart';
import 'app_extractor.dart';
// Impor layar-layar terkait (pastikan jalurnya sesuai project-mu)

List<RouteBase> buildFullscreenRoutes(
    GlobalKey<NavigatorState> rootNavigatorKey) {
  return [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/map',
      builder: (context, state) => const WindowsMapView(),
    ),
    GoRoute(
      path: '/user-profile',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const UserProfileScreen(),
    ),
    GoRoute(
      path: '/shop-profile',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ShopProfileScreen(),
    ),
    GoRoute(
      path: '/order',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OrderScreen(),
    ),
    GoRoute(
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
