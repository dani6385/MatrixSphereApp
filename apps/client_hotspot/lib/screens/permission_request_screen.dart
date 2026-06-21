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
      return;
    }

    // FIX: Unified dialog for both denied and permanentlyDenied states for better UX.
    String title;
    String content;
    String confirmText;
    VoidCallback onConfirm;

    if (status.isPermanentlyDenied) {
      title = 'Izin Dibutuhkan Secara Permanen';
      content = 'Untuk fungsionalitas penuh, aplikasi ini memerlukan izin notifikasi. Silakan aktifkan secara manual di pengaturan aplikasi Anda.';
      confirmText = 'Buka Pengaturan';
      onConfirm = () {
        openAppSettings();
        Navigator.of(context).pop();
      };
    } else { // Handles the .denied case
      title = 'Izin Diperlukan';
      content = 'Izin notifikasi penting untuk memberi Anda pembaruan status dan promo. Tanpa itu, beberapa fitur mungkin tidak berfungsi.';
      confirmText = 'Coba Lagi';
      onConfirm = () {
        Navigator.of(context).pop();
        _requestPermission(); // Ask for permission again
      };
    }

    showDialog(
      context: context,
      barrierDismissible: false, // User must interact with the dialog
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('Nanti Saja'),
            onPressed: () => Navigator.of(context).pop(), // Allow user to dismiss
          ),
          ElevatedButton(
            child: Text(confirmText),
            onPressed: onConfirm,
          ),
        ],
      ),
    );
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
