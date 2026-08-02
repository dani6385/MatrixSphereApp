import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'navigation/bottom_nav_bar.dart';
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
  late final AuthBloc _authBloc; // Keep existing bloc initialization
  int _selectedIndex = 0; // Add state to manage the current index of the bottom nav bar

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(authService: AuthService());
    // Initialize _selectedIndex if needed, e.g., from saved preferences
  }

  // Callback function for when a bottom navigation bar item is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Implement navigation logic here based on the selected index.
    // This might involve using GoRouter to navigate to different routes
    // or updating the body of the Scaffold.
    debugPrint('Tapped on index: $index');

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
          return MaterialApp(
            title: 'Seller Sphere',
            debugShowCheckedModeBanner: false,
            // --- KONFIGURASI TEMA ---
            // Tema yang digunakan saat sistem dalam mode terang (light mode)
            theme: AppTheme.lightTheme,

            // Tema yang digunakan saat sistem dalam mode gelap (dark mode)
            darkTheme: AppTheme.darkTheme,

            // Ini adalah kuncinya: aplikasi akan mengikuti pengaturan sistem
            themeMode: ThemeMode.system,

            // Konfigurasi router dari GoRouter
            // The 'bottom_nav_bar' parameter is not a valid property for MaterialApp.
            // Instead, the BottomNavBar should be placed within a Scaffold's bottomNavigationBar property.
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Seller Sphere'), // Placeholder AppBar title
              ),
              body: Center(
                child: Text('Content for tab $_selectedIndex'), // Placeholder body content
              ),
              bottomNavigationBar: BottomNavBar(currentIndex: _selectedIndex, onTap: _onItemTapped),
            ),
          );
        },
      ),
    );
  }
}
