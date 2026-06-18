import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Impor LoginScreen
import 'package:http/http.dart' as http;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hubungkan ke Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}

Future<bool> checkInternetAccess() async {
  try {
    // Mencoba melakukan request ke situs publik
    final response = await http
        .get(Uri.parse('https://www.google.com'))
        .timeout(const Duration(seconds: 5));
    return response.statusCode == 200;
  } catch (e) {
    return false; // Gagal terhubung ke internet
  }
}
