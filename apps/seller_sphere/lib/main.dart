import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:provider/provider.dart';
import 'package:seller_sphere/navigations/app_router.dart';
//import 'package:go_router/go_router.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

void main() async {
  // 1. Pastikan binding diinisialisasi terlebih dahulu
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Coba inisialisasi Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 3. Set up Crashlytics hanya jika Firebase berhasil diinisialisasi
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    debugPrint("Firebase & Crashlytics berhasil dikonfigurasi.");
  } catch (e, stack) {
    // Jika Firebase gagal, aplikasi TIDAK AKAN layar hitam, melainkan tetap berjalan
    // dan menampilkan pesan error ini di konsol debug Anda.
    debugPrint("Gagal menginisialisasi Firebase: $e");
    debugPrint(stack.toString());
  }

  // 4. Selalu panggil runApp di luar blok inisialisasi agar layar hitam terhindari
  runApp(const SellerSphere());
}

class SellerSphere extends StatefulWidget {
  const SellerSphere({super.key});

  @override
  State<SellerSphere> createState() => _SellerSphereState();
}

class _SellerSphereState extends State<SellerSphere> {
  ThemeMode? get currentThemeMode => null;

  @override
  Widget build(BuildContext context) {
    // MultiProvider dan BlocProvider dapat ditambahkan kembali di sini jika ada state lain yang perlu dikelola secara global.
    // Untuk routing saja, ini tidak lagi diperlukan.
    /*return MultiProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        //ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      // BlocListener tidak lagi diperlukan di sini karena GoRouter
      // akan menangani redirect secara otomatis berdasarkan perubahan state.
      child: Builder(
        builder: (context) {*/
    return MaterialApp.router(
      title: 'Seller Sphere',
      debugShowCheckedModeBanner: false,
      // --- KONFIGURASI TEMA ---
      // Tema yang digunakan saat sistem dalam mode terang (light mode)
      theme: AppTheme.lightTheme,

      // Tema yang digunakan saat sistem dalam mode gelap (dark mode)
      darkTheme: AppTheme.darkTheme,

      // Ini adalah kuncinya: aplikasi akan mengikuti pengaturan sistem
      themeMode: currentThemeMode,

      // Konfigurasi router dari GoRouter
      routerConfig: appRouter, // Menggunakan variabel appRouter langsung
    );
    /*},
      ),*/
  }
}
