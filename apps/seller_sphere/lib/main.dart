import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_sphere/providers/theme_provider.dart';
import 'package:seller_sphere/widgets/app_router.dart'; // Impor app_router.dart
import 'package:shared_ui/shared_ui.dart';

// Provider yang mungkin masih relevan untuk didefinisikan di sini
// jika mereka adalah ChangeNotifier lama yang belum dimigrasi.
// Untuk sekarang kita biarkan kosong karena sebagian besar sudah dimigrasi.

void main() {
  runApp(const ProviderScope(child: SellerApp()));
}

class SellerApp extends ConsumerWidget {
  const SellerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Dapatkan instance GoRouter dari goRouterProvider
    final router = ref.watch(goRouterProvider);
    // 2. Dapatkan state tema dari themeProvider (yang sudah Riverpod)
    final isDarkMode = ref.watch(themeProvider);

    // 3. Gunakan MaterialApp.router dengan konfigurasi yang bersih
    return MaterialApp.router(
      routerConfig: router,
      title: 'Seller Sphere',
      theme: SharedTheme.lightTheme,       // Tema terang default
      darkTheme: SharedTheme.darkTheme,     // Tema gelap default
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light, // Terapkan tema berdasarkan state
    );
  }
}
