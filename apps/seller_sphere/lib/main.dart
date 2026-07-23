import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/navigation/app_extraktor.dart';
import 'package:seller_sphere/navigation/go_router_refresh_stream.dart';
import 'package:seller_sphere/screens/login/widgets/forgot_password_page.dart';
import 'package:seller_sphere/screens/inventory/providers/app_provider.dart';

import 'package:shared_services/shared_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Ganti dengan path home screen Anda

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

// Pindahkan GoRouter ke luar kelas agar menjadi top-level variable.
// Ini adalah praktik terbaik untuk memastikan router tidak dibuat ulang.
final GoRouter _router = GoRouter(
  initialLocation: '/login', // Mulai dari halaman login
  // 1. Redirect logic
  redirect: (BuildContext context, GoRouterState state) {
    // Dapatkan status login pengguna saat ini dari AuthBloc
    final authState = context.read<AuthBloc>().state;
    final bool isLoggedIn = authState is AuthSuccess;

    // Dapatkan lokasi yang sedang dituju
    final String location = state.uri.toString();

    // Daftar halaman publik yang bisa diakses tanpa login
    final bool isPublicPage = location == '/login' ||
        location == '/register' ||
        location == '/forgot-password';

    // Skenario:
    // - Jika pengguna BELUM login dan TIDAK sedang menuju halaman publik,
    //   maka alihkan (redirect) ke halaman login.
    if (!isLoggedIn && !isPublicPage) {
      return '/login';
    }

    // - Jika pengguna SUDAH login dan sedang mencoba mengakses halaman publik,
    //   maka alihkan ke halaman utama (home).
    if (isLoggedIn && isPublicPage) {
      return '/';
    }

    // - Jika tidak ada kondisi di atas yang terpenuhi, jangan lakukan redirect.
    return null;
  },
  refreshListenable:
      GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  // 2. Daftar semua rute aplikasi Anda
  routes: <RouteBase>[
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
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterPage();
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (BuildContext context, GoRouterState state) {
        return const ForgotPasswordPage();
      },
    ),
    // Tambahkan rute lain di sini, contoh:
    GoRoute(
      path: '/sellers',
      builder: (BuildContext context, GoRouterState state) {
        return const SellerScreen();
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

class SellerSphere extends StatefulWidget {
  const SellerSphere({super.key});

  @override
  State<SellerSphere> createState() => _SellerSphereState();
}

class _SellerSphereState extends State<SellerSphere> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(authService: AuthService());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      // BlocListener tidak lagi diperlukan di sini karena GoRouter
      // akan menangani redirect secara otomatis berdasarkan perubahan state.
      child: Builder(
        builder: (context) {
          // Add return statement here
          return MaterialApp.router(
            title: 'Seller Sphere',
            theme: ThemeData.dark(), // Menggunakan tema dari shared_ui
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
