import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/shared_ui.dart';

import 'app_navigation.dart';


void main() {
  // Memastikan semua binding Flutter siap sebelum aplikasi berjalan.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // Membungkus aplikasi dengan ProviderScope agar state management Riverpod
    // tersedia di seluruh aplikasi.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil tema teks default dan menggantinya dengan Google Fonts (Poppins)
    final textTheme = Theme.of(context).textTheme;
    final poppinsTheme = GoogleFonts.poppinsTextTheme(textTheme);

    return MaterialApp.router(
      title: 'Shop Sphere',
      debugShowCheckedModeBanner: false,
      // Menggunakan router dari AppNavigation yang ada di shared_ui
      routerConfig: AppNavigation.router,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        textTheme: poppinsTheme,
        useMaterial3: true,
      ),
    );
  }
}
