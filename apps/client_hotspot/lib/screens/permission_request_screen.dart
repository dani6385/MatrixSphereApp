import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_screen.dart'; // Assuming your main screen is HomeScreen

class PermissionRequestScreen extends StatefulWidget {
  const PermissionRequestScreen({super.key});

  @override
  State<PermissionRequestScreen> createState() => _PermissionRequestScreenState();
}

class _PermissionRequestScreenState extends State<PermissionRequestScreen> {

  @override
  void initState() {
    super.initState();
    // Check permission status on screen initialization
    _checkPermission();
  }

  Future<void> _checkPermission() async {
      final status = await Permission.notification.status;
      if (!mounted) return;
      if (status.isGranted) {
          _navigateToHome();
      }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  Future<void> _requestPermission() async {
    final status = await Permission.notification.request();
    if (!mounted) return;
    if (status.isGranted) {
      _navigateToHome();
    } else if (status.isPermanentlyDenied) {
      // Show a dialog to open app settings if permission is permanently denied
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Izin Diperlukan'),
          content: const Text('Aplikasi ini memerlukan izin notifikasi untuk berfungsi. Silakan aktifkan di pengaturan aplikasi.'),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Buka Pengaturan'),
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin notifikasi diperlukan untuk melanjutkan.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_active,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              const Text(
                'Aktifkan Notifikasi',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Kami memerlukan izin Anda untuk mengirimkan notifikasi penting terkait status koneksi, masa aktif paket, dan promo menarik.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _requestPermission,
                child: const Text('Izinkan Notifikasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
