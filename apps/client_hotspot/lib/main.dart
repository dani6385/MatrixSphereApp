import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../screens/navigation_layout.dart';
import 'firebase_options.dart';

void main() async {
  // Di apps/admin_mikrotik/lib/main.dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  // Jadikan main sebagai fungsi async
  // Pastikan Flutter binding telah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase
  await Firebase.initializeApp();
  // Jalankan aplikasi
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client Hotspot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const NavigationLayout(), // Atur NavigationLayout sebagai home
    );
  }
}
