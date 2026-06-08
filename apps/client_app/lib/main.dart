import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart'; 
import 'package:shared_core/shared_core.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase melalui Service yang sudah Anda buat
  await FirebaseService.initialize();

  // Setup Dependency Injection (Service Locator)
  setupLocator();

  runApp(const MatrixSphereApp());
}

class MatrixSphereApp extends StatelessWidget {
  const MatrixSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matrix Sphere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
    );
  }
}
