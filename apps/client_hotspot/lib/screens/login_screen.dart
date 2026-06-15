import 'dart:io';
import 'package:flutter/material.dart';
import '../auth/mikrotik_auth.dart'; // Pastikan file mikrotik_auth.dart sudah diimport
import 'dart:async';
import 'navigation_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Instantiate MikrotikAuth with required loginUrl parameter
  final dynamic auth = MikrotikAuth(loginUrl: 'http://192.168.30.1/login');
  final TextEditingController myUsernameController = TextEditingController();
  final TextEditingController myPasswordController = TextEditingController();

  // Fungsi pembantu untuk memicu proses login
  void _showLoginDialog(BuildContext context, String type) {
    TextEditingController userController = TextEditingController();
    TextEditingController passController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Login $type"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: userController,
                decoration: InputDecoration(labelText: "Username")),
            if (type == "Member")
              TextField(
                  controller: passController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String user = myUsernameController.text;
              String pass = type == "Member" ? myPasswordController.text : '';

              try {
                await auth.login(user, pass);
                // --- TAMBAHKAN CEK MOUNTED DI SINI ---
                if (!context.mounted) return;
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Login Sukses!")),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NavigationLayout()),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: Text("Login"),
          )
        ],
      ),
    );
  }

  // Periksa akses internet dengan mencoba lookup DNS sederhana
  Future<bool> checkInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('http://192.168.30.1');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> checkInternetAccessWithRetry(
      {int maxRetries = 3, Duration delay = const Duration(seconds: 2)}) async {
    for (int i = 0; i < maxRetries; i++) {
      bool isConnected =
          await checkInternetAccess(); // Menggunakan fungsi checkInternetAccess kita sebelumnya

      if (isConnected) {
        return true; // Berhasil terhubung
      }

      // Jika belum, tunggu beberapa saat sebelum mencoba lagi
      if (i < maxRetries - 1) {
        await Future.delayed(delay);
      }
    }
    return false; // Gagal setelah beberapa kali percobaan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tombol Voucher
            ElevatedButton(
              onPressed: () => _showLoginDialog(context, "Voucher"),
              child: Text("Login Voucher"),
            ),
            SizedBox(height: 20),
            // Tombol Member
            ElevatedButton(
              onPressed: () => _showLoginDialog(context, "Member"),
              child: Text("Login Member"),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // Jangan lupa membersihkan controller saat layar ditutup
    myUsernameController.dispose();
    myPasswordController.dispose();
    super.dispose();
  }
  
  // ... sisa kode Anda
}

