import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart'; // Menggunakan barrel file utama

import 'screens/login_screen.dart'; // Impor LoginScreen

void main() {
  // Pastikan service locator diinisialisasi sebelum aplikasi berjalan
  // Meskipun kosong untuk saat ini, ini adalah pola arsitektur yang benar
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Atur LoginScreen sebagai halaman utama
      home: LoginScreen(),
    );
  }
}
