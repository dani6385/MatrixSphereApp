import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_services/shared_services.dart';
import '../auth/mikrotik_auth.dart';
import '../dialog/member_dialog.dart';
import '../dialog/voucher_dialog.dart';
import './navigation_layout.dart'; // Mengarah ke NavigationLayout

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logger _logger = Logger();
  final MikrotikAuth _auth =
      MikrotikAuth(loginUrl: 'http://192.168.30.1/login');

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn && mounted) {
      _logger.i("User sudah login, langsung ke NavigationLayout.");
      // PERBAIKAN: Menggunakan navigasi yang lebih kuat
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const NavigationLayout()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _handleLogin(
      {required String username, String password = ''}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    bool success = false;
    String? errorMessage;

    try {
      success = await _auth.login(username: username, password: password);
    } catch (e) {
      errorMessage = e.toString();
    }

    if (!mounted) return; // Guard against async gap

    Navigator.pop(context); // Tutup loading indicator

    if (success) {
      _logger.i("Login berhasil, menyimpan status & navigasi ke NavigationLayout.");
      await AuthService.setLoggedIn(true, username);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Berhasil!'),
          backgroundColor: Colors.green,
        ),
      );
      // PERBAIKAN: Menggunakan navigasi yang lebih kuat untuk memastikan pindah halaman
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const NavigationLayout()),
        (Route<dynamic> route) => false, // Hapus semua halaman sebelumnya
      );
    } else {
      _logger.w("Login gagal. Pesan error: $errorMessage");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Login Gagal. Periksa kembali data Anda.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showVoucherDialog() async {
    final voucherCode = await showVoucherDialog(context);
    if (voucherCode != null && voucherCode.isNotEmpty) {
      _logger.i("Mencoba login dengan voucher: $voucherCode");
      await _handleLogin(username: voucherCode, password: voucherCode);
    }
  }

  void _showMemberDialog() async {
    final credentials = await showMemberLoginDialog(context);
    if (credentials != null &&
        credentials['username'] != null &&
        credentials['password'] != null) {
      _logger.i("Mencoba login member: ${credentials['username']}");
      await _handleLogin(
        username: credentials['username']!,
        password: credentials['password']!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotspot Login'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.wifi, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              const Text(
                'Selamat Datang',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Silakan pilih metode login Anda',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.confirmation_number),
                label: const Text('Login Voucher'),
                onPressed: _showVoucherDialog,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                icon: const Icon(Icons.person),
                label: const Text('Login Member'),
                onPressed: _showMemberDialog,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
