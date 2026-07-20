import 'package:flutter/foundation.dart'; // Tambahkan import ini untuk PlatformDispatcher
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:shared_services/shared_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';
import 'routes/app_router.dart';
// Pastikan firebase_options diimport jika Anda menggunakannya secara lokal:
// import 'firebase_options.dart'; 

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

class SellerSphere extends StatelessWidget {
  const SellerSphere({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Ganti ke MaterialApp.router
          return MaterialApp.router(
            title: 'Seller Sphere',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            routerConfig: appRouter, // Gunakan konfigurasi router baru
          );
        },
      ),
    );
  }
}
