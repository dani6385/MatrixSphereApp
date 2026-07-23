import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/navigation/app_router.dart';
import 'package:seller_sphere/auth/auth_bloc.dart';
import 'package:seller_sphere/auth/auth_service.dart';
import 'package:seller_sphere/screens/inventory/providers/app_provider.dart';
import 'package:shared_services/shared_services.dart';

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
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(authService: AuthService());
    _router = appRouter;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Jika login atau registrasi berhasil, arahkan ke halaman utama.
            // GoRouter akan menangani penggantian stack navigasi.
            context.go('/');
          }
        },
        child: MaterialApp.router(
          title: 'Seller Sphere',
          theme: ThemeData.dark(), // Menggunakan tema dari shared_ui
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
        ),
      ),
    );
  }
}