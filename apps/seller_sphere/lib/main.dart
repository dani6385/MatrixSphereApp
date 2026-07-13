import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seller_sphere/app_scaffold.dart';
import 'package:shared_ui/shared_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Wajib ada!
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seller Sphere',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: kBrandPrimary,
          brightness: Brightness.dark,
          surface: kDarkBackground,
        ),
        useMaterial3: true,
      ),
      home: const SellerSphereScaffold(),
    );
  }
}
