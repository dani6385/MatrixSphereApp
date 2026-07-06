import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matrix_sphere_app/config/router/app_router.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart'; // 1. Impor shared_ui

void main() async {
  // Pastikan binding Flutter sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Jalankan aplikasi dengan ProviderScope untuk Riverpod
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Matrix Sphere',
      // 2. Terapkan AppTheme.lightTheme
      theme: AppTheme.lightTheme, 
      // Gunakan konfigurasi router dari app_router.dart
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}