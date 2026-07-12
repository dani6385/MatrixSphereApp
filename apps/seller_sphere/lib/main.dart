import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/screens/home_screen.dart';
import 'package:seller_sphere/viewmodels/app_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppViewModel(),
      child: MaterialApp(
        title: 'Seller Sphere',
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade300,
            brightness: Brightness.dark,
            surface: const Color(0xFF1E1E1E),
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
