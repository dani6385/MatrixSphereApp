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
    // Gunakan addPostFrameCallback untuk memastikan context sudah siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  void _checkLoginStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn && mounted) {
      _logger.i("User sudah login, langsung ke NavigationLayout.");
      // Gunakan setState untuk navigasi yang aman
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const NavigationLayout()),
          (Route<dynamic> route) => false,
        );
      });
    } else {
      _logger.i("User belum login.");
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
      _logger.i(
          "Login berhasil, menyimpan status & navigasi ke NavigationLayout.");
      await AuthService.setLoggedIn(true, username);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Berhasil!'),
          backgroundColor: Colors.green,
        ),
      );
      // Gunakan setState untuk navigasi yang aman
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const NavigationLayout()),
          (Route<dynamic> route) => false, // Hapus semua halaman sebelumnya
        );
      });
    } else {
      _logger.w("Login gagal. Pesan error: $errorMessage");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(errorMessage ?? 'Login Gagal. Periksa kembali data Anda.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3D2F8), Color(0xFFF0E5F8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi, size: 64, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text(
              'Selamat Datang',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Text(
              'Silakan pilih metode login Anda',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            _buildLoginButton(
              text: 'Login Voucher',
              icon: Icons.confirmation_number,
              onPressed: () => showVoucherDialog(context, _handleLogin),
            ),
            const SizedBox(height: 20),
            _buildLoginButton(
              text: 'Login Member',
              icon: Icons.person,
              onPressed: () => showMemberLoginDialog(context, _handleLogin),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.deepPurple),
      label: Text(text, style: const TextStyle(color: Colors.deepPurple)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(250, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
    );
  }
}
