// lib/navigation/app_common_routes.dart

import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
//import 'app_routes.dart';
//import 'package:shared_services/shared_services.dart';
//import 'app_extractor.dart';

/// Kunci navigator global yang diimpor dari file router utama.
late final GlobalKey<NavigatorState> commonRootNavigatorKey;

/// Daftar rute umum yang dapat diakses dari berbagai tab di atas Shell.
/*final List<RouteBase> commonDetailRoutes = [
  GoRoute(
    path: AppRoutes.settings.substring(1),
    builder: (context, state) => const SettingScreen(),
  ),
  GoRoute(
    path: AppRoutes.chat.substring(1),
    builder: (context, state) => const ChatScreen(),
  ),
  GoRoute(
    path: 'products/:productId',
    builder: (context, state) => ProductDetailScreen(
      productId: state.pathParameters['productId']!, shopId: '',
    ),
  ),
];*/