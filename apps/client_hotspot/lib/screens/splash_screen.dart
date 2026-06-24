import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isDeveloperMode = true; // Default ke true untuk menunjukkan pengecekan awal

  @override
  void initState() {
    super.initState();
    _checkInitialStatus();
  }

  Future<void> _checkInitialStatus() async {
    // Pengecekan pertama kali saat aplikasi dimulai
    bool developerMode = await FlutterJailbreakDetection.developerMode;
    setState(() {
      _isDeveloperMode = developerMode;
    });

    if (!developerMode) {
      // Jika mode developer tidak aktif, lanjutkan ke permintaan izin
      _requestPermissionsAndNavigate();
    } 
  }

  Future<void> _requestPermissionsAndNavigate() async {
    // Meminta izin yang diperlukan
    await [
      Permission.camera,
      Permission.storage, 
      Permission.notification,
    ].request();

    // Menunggu sejenak
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      context.go('/home');
    }
  }

  // UI untuk layar peringatan
  Widget _buildWarningScreen() {
    return Scaffold(
      backgroundColor: Colors.red.shade800,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                'Keamanan Terdeteksi',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 15),
              const Text(
                'Untuk melanjutkan, Anda harus mematikan "Opsi Pengembang" (Developer Options) di pengaturan perangkat Anda. Aplikasi akan menutup setelah Anda menekan tombol.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red.shade800,
                ),
                onPressed: () {
                   // Membuka pengaturan opsi pengembang
                   AppSettings.openAppSettings(type: AppSettingsType.developer);
                },
                child: const Text('Buka Pengaturan Opsi Pengembang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // UI untuk layar splash normal
  Widget _buildSplashScreen() {
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
                'Memeriksa keamanan & meminta izin...',
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

  @override
  Widget build(BuildContext context) {
    // Tampilkan layar peringatan jika mode developer aktif
    // Jika tidak, tampilkan layar splash biasa sambil menunggu pengecekan selesai
    return _isDeveloperMode ? _buildWarningScreen() : _buildSplashScreen();
  }
}
