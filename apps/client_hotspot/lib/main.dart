import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart'; // Menggunakan barrel file utama
import 'screens/login_screen.dart'; // Impor LoginScreen

void main() {
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
