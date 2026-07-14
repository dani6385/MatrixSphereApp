import 'package:flutter/material.dart';
import 'package:seller_sphere/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seller Sphere',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
