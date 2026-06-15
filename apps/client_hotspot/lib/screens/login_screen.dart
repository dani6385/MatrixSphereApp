//import 'dart:io';
import 'package:flutter/material.dart';
import '../auth/mikrotik_auth.dart'; // Pastikan file mikrotik_auth.dart sudah diimport
import 'dart:async';
//import 'navigation_layout.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
final Logger _logger = Logger();
class _LoginScreenState extends State<LoginScreen> {
  // Instantiate MikrotikAuth with required loginUrl parameter
  final TextEditingController myUsernameController = TextEditingController();
  final TextEditingController myPasswordController = TextEditingController();
  String loginMethod = 'member';
  @override
  void dispose() {
    myUsernameController.dispose();
    myPasswordController.dispose();
    super.dispose();
  }
  Future<void> _handleLogin() async {
    final auth = MikrotikAuth(loginUrl: 'http://192.168.30.1/login');
    
    // Debugging: cek apakah teks terbaca
    _logger.d("Mencoba login dengan: ${myUsernameController.text}");

    bool berhasil = await auth.login(
      username: myUsernameController.text,
      password: myPasswordController.text,
    );
    if (!mounted) return;
    if (berhasil) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Berhasil!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login Gagal, periksa koneksi/kredensial")));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Member/Voucher")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Tombol Pilihan Metode
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => loginMethod = 'voucher'),
                  child: const Text("Voucher"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => setState(() => loginMethod = 'member'),
                  child: const Text("Member"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Input Field
            TextField(
              controller: myUsernameController,
              decoration: InputDecoration(labelText: loginMethod == 'voucher' ? 'Kode Voucher' : 'Username'),
            ),
            TextField(
              controller: myPasswordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            
            // Tombol Login
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}