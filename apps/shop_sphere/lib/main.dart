import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_router.dart'; // Mengimpor konfigurasi router
import 'providers/device_provider.dart';
import 'providers/session_provider.dart';
import 'presentation/cart_screens/providers/cart_provider.dart';
import 'presentation/order_screens/providers/order_provider.dart';
import 'presentation/product_screens/provider/review_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()), // Pastikan CartProvider diimpor dengan benar
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: MaterialApp.router(
        title: 'MatrixSphere App',
        routerConfig: appRouter,
        theme: ThemeData.dark(),
      ),
    );
  }
}