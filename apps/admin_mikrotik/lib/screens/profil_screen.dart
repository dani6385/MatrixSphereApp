import 'package:flutter/material.dart';
import 'package:admin_mikrotik/screens/login_screen.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Kembali ke LoginScreen dan hapus semua rute sebelumnya
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false, // Hapus semua rute
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
