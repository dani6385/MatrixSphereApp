import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/navigation/app_extraktor.dart';
import 'package:seller_sphere/services/product_service.dart';
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
// 2. BUAT GLOBAL KEY UNTUK NAVIGATOR
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter _router = GoRouter(
  initialLocation: '/login', // Mulai dari halaman login
  redirect: (BuildContext context, GoRouterState state) async {
    final user = FirebaseAuth.instance.currentUser;
    final bool isLoggedIn = user != null;

    // Dapatkan lokasi yang sedang dituju
    final String location = state.uri.toString();

    // Daftar halaman publik yang bisa diakses tanpa login
    final publicPages = ['/login', '/login/register', '/login/forgot-password'];
    final bool isPublicPage = publicPages.contains(location);

    // --- LOGIKA REDIRECT ---

    // 1. Jika pengguna BELUM login dan mencoba mengakses halaman non-publik,
    //    arahkan ke halaman login.
    if (!isLoggedIn && !isPublicPage) {
      return '/login';
    }

    // 2. Jika pengguna SUDAH login:
    if (isLoggedIn && isPublicPage) {
      // 2a. Jika mencoba mengakses halaman publik (login, register),
      //     arahkan ke halaman utama.
      if (isPublicPage) {
        return '/';
      }

      // 2b. Periksa apakah pengguna sudah memiliki toko atau sedang dalam proses approval.
      //     Ini adalah logika baru yang ditambahkan.
      final rtdbService = FirebaseRtdbService();
      final bool hasShop = await rtdbService.doesShopExistForUser(user.uid);

      // Lokasi halaman pendaftaran toko
      const registerShopLocation = '/register-shop';
      final bool isAtRegisterShopPage = location == registerShopLocation;

      // Jika pengguna tidak punya toko DAN tidak sedang di halaman pendaftaran toko,
      // paksa arahkan ke halaman pendaftaran toko.
      if (!hasShop && !isAtRegisterShopPage) {
        return registerShopLocation;
      }

      // Jika pengguna punya toko TAPI mencoba akses halaman pendaftaran,
      // kembalikan ke halaman utama.
      if (hasShop && isAtRegisterShopPage) {
        return '/';
      }
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
          bottomNavigationBar: BottomNavBar(
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => navigationShell.goBranch(index),
          ),
        );
      },
      branches: [
        // Branch 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Branch 2: Streaming (Sesuai urutan di bottom_nav_bar.dart)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stream',
              builder: (context, state) => const StreamingScreen(),
            ),
          ],
        ),
        // Branch 3: Inventory
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inventory',
              builder: (context, state) =>
                  const InventoryScreen(), // Disederhanakan, logika navigasi dipindah ke dalam
            ),
            // Rute untuk form tambah/edit produk, di dalam branch inventory
            GoRoute(
              path: '/inventory/add',
              name: 'addProduct',
              parentNavigatorKey: _rootNavigatorKey, // Tampil fullscreen
              builder: (context, state) => const ProductFormScreen(),
            ),
            GoRoute(
              path: '/inventory/edit',
              name: 'editProduct',
              parentNavigatorKey: _rootNavigatorKey, // Tampil fullscreen
              builder: (context, state) => ProductFormScreen(initialProduct: state.extra as Product?),
            ),
          ],
        ),
        // Branch 4: Status (orderan)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/status',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Chat'))),
            ),
          ],
        ),
        // Branch 5: Absen (Attendance)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/attendance',
              builder: (context, state) => const AttendanceScreen(),
            ),
          ],
        ),
      ],
    ),

    // Rute yang TIDAK memiliki BottomNavigationBar (fullscreen)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/login/register',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/login/forgot-password',
      builder: (context, state) => const LoginScreen(),
    ),
    // Rute untuk pendaftaran toko (fullscreen)
    GoRoute(
      path: '/register-shop',
      builder: (context, state) => const RegisterShopScreen(),
    ),
    // Tambahkan rute fullscreen lain di sini (register, forgot-password, dll.)
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
        BlocProvider(
          create: (context) => ProductBloc(productService: ProductService())
            ..add(const ProductsSubscriptionRequested()),
        ),
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
