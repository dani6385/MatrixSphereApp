import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/Dashboard_Screen.dart';
import 'screens/login_screen.dart';

void main() async {
  // Wajib dipanggil untuk memastikan binding ke engine Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ambil status login dari penyimpanan lokal
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Jalankan aplikasi dengan status login yang sudah dicek
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MatrixSphere',
      // Jika isLoggedIn true, ke Dashboard, jika tidak ke LoginScreen
      home: isLoggedIn ? const DashboardScreen() : const LoginScreen(),
    );
  }
}