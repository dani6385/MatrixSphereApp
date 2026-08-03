import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _permFlagKey = 'permissionsGranted';

  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // GoRouter's redirect logic will handle navigation automatically.
    // This screen's only job is to initialize what's needed on first launch,
    // like permissions.
    final prefs = await SharedPreferences.getInstance();
    final alreadyGranted = prefs.getBool(_permFlagKey) ?? false;

    if (!alreadyGranted) {
      // Meminta izin sesuai dengan konfigurasi di Info.plist
      await [
        Permission.camera,
        Permission.photos,
        Permission.locationWhenInUse,
      ].request();
      await prefs.setBool(_permFlagKey, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mengganti FlutterLogo dengan logo aplikasi Anda dari assets.
            Image.asset(
              'assets/images/logo.png',
              width: 150, // Anda bisa menyesuaikan ukurannya di sini
            ),
            const SizedBox(height: 20),
            const Text(
              'Selamat Datang!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Mempersiapkan aplikasi...',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
        

