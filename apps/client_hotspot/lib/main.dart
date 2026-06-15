import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart'; // Impor LoginScreen
import 'firebase_options.dart';

void main() async {
  // 1. Pastikan Flutter terhubung dulu
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inisialisasi Firebase (Wajib ada di Flutter Web)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // 3. Baru jalankan aplikasi
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
