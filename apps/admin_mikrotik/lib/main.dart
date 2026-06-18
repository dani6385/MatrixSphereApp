import 'package:flutter/material.dart';
import 'package:admin_mikrotik/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Mikrotik',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, // Recommended for modern UI
      ),
      home: const LoginScreen(), // Set LoginScreen as the home screen
    );
  }
}
