import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/auth/auth_bloc.dart';
import 'package:seller_sphere/auth/auth_service.dart';
import 'package:seller_sphere/screens/inventory/providers/app_provider.dart';
import 'package:shared_services/shared_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:seller_sphere/screens/home/home_screen.dart'; // Ganti dengan path home screen Anda
import 'package:seller_sphere/screens/login/login_page.dart';

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
// File: d:\MatrixSphereApp\apps\seller_sphere\lib\navigation\app_router.dart

// Dapatkan instance GoRouter
  final GoRouter appRouter = GoRouter(
    // 1. Redirect logic
    redirect: (BuildContext context, GoRouterState state) {
      // Dapatkan status login pengguna saat ini
      final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;

      // Dapatkan lokasi yang sedang dituju
      final String location = state.uri.toString();

      // Cek apakah pengguna sedang menuju halaman login
      final bool isGoingToLogin = location == '/login';

      // Skenario:
      // - Jika pengguna BELUM login dan TIDAK sedang menuju halaman login,
      //   maka alihkan (redirect) ke halaman login.
      if (!isLoggedIn && !isGoingToLogin) {
        return '/login';
      }

      // - Jika pengguna SUDAH login dan sedang mencoba mengakses halaman login,
      //   maka alihkan ke halaman utama (home).
      if (isLoggedIn && isGoingToLogin) {
        return '/';
      }

      // - Jika tidak ada kondisi di atas yang terpenuhi, jangan lakukan redirect.
      return null;
    },

    // 2. Daftar semua rute aplikasi Anda
    routes: <RouteBase>[
      // The initial route that displays the splash screen.
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          // Ini adalah halaman utama (home) Anda
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      // Tambahkan rute lain di sini, contoh:
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
      ),
    ],

    // 3. Halaman error jika rute tidak ditemukan
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Halaman tidak ditemukan: ${state.error}'),
      ),
    ),
  );

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
