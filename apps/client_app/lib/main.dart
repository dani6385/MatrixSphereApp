
import 'package:flutter/material.dart';
import 'login_options_screen.dart'; // Mengimpor layar yang sudah kita pindahkan

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Klien',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Menjadikan LoginOptionsScreen sebagai halaman utama
      home: const LoginOptionsScreen(),
    );
  }
}
