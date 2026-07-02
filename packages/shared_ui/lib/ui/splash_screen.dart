import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final alreadyGranted = prefs.getBool(_permFlagKey) ?? false;
    if (!alreadyGranted) {
      // Request permissions only once (uncomment if needed)
      /*late*/ [
        // Permission.camera,
        // Permission.storage,
        // Permission.notification,
      ];
      await prefs.setBool(_permFlagKey, true);
    }
    // Small delay for splash experience
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // Arahkan ke halaman login setelah splash screen
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 20),
            Text(
              'Selamat Datang!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Mempersiapkan aplikasi...',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
