import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shop_sphere/presentation/home_screens/home_screen.dart';

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

    return MaterialApp(
      title: 'Shop Sphere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        textTheme: poppinsTheme,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
