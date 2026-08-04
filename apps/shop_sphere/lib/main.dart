import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
//import 'package:shop_sphere/navigation/app_extraktor.dart';
//import 'package:shop_sphere/navigation/bottom_nav_bar.dart'; // 1. IMPORT WIDGET SHELL

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
  runApp(const ShopSphere());
}

// Pindahkan GoRouter ke luar kelas agar menjadi top-level variable.
// Ini adalah praktik terbaik untuk memastikan router tidak dibuat ulang.
// 2. BUAT GLOBAL KEY UNTUK NAVIGATOR
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  //initialLocation: '/login', // Mulai dari halaman login
  // 1. Redirect logic
  redirect: (BuildContext context, GoRouterState state) {
    // --- PERUBAHAN DIMULAI DI SINI ---
    // Gunakan status langsung dari FirebaseAuth untuk menghindari race condition
    // dengan state BLoC. Ini lebih andal untuk redirect.
    final bool isLoggedIn = FirebaseAuth.instance.currentUser != null;
    // final authState = context.read<AuthBloc>().state; // Baris ini tidak lagi diperlukan
    // final bool isLoggedIn = authState is AuthSuccess; // Baris ini diganti

    // Dapatkan lokasi yang sedang dituju
    final String location = state.uri.toString();

    // Daftar halaman publik yang bisa diakses tanpa login
    final bool isPublicPage = location == '/login' ||
        location == '/login/register' ||
        location == '/login/forgot-password';

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
    // --- PERUBAHAN SELESAI DI SINI ---
  },
  refreshListenable:
      GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),

  // 3. UBAH STRUKTUR RUTE
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    // Rute yang memiliki BottomNavigationBar (di dalam Shell)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // PERBAIKAN: Bungkus navigationShell (konten halaman) dan BottomNavBar
        // di dalam sebuah Scaffold.
        return Scaffold(
          body:
              navigationShell, // navigationShell akan menampilkan halaman aktif
          /*bottomNavigationBar: BottomNavBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(index),
          ),*/
        );
      },
      branches: [
        // Branch 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              //builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Branch 2: Streaming (Sesuai urutan di bottom_nav_bar.dart)
        
      ],
    ),

    // Rute yang TIDAK memiliki BottomNavigationBar (fullscreen)
    
    // Tambahkan rute fullscreen lain di sini (register, forgot-password, dll.)
  ],

  // 3. Halaman error jika rute tidak ditemukan
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
);

class ShopSphere extends StatefulWidget {
  const ShopSphere({super.key});

  @override
  State<ShopSphere> createState() => _ShopSphereState();
}

class _ShopSphereState extends State<ShopSphere> {
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
        //ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      // BlocListener tidak lagi diperlukan di sini karena GoRouter
      // akan menangani redirect secara otomatis berdasarkan perubahan state.
      child: Builder(
        builder: (context) {
          // Add return statement here
          return MaterialApp.router(
            title: 'Shop Sphere',
            theme: ThemeData.dark(), // Menggunakan tema dari shared_ui
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
