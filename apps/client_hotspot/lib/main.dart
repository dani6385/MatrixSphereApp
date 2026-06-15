import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Impor LoginScreen
import 'auth/mikrotik_auth.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

extension MikrotikAuthLoginStatus on MikrotikAuth {
  Future<bool> isLoggedIn() async {
    try {
      return await (this as dynamic).isLoggedIn() as bool;
    } on NoSuchMethodError {
      return false;
    }
  }
}
final Logger _logger = Logger();
void checkAuthStatus() async {
  MikrotikAuth auth = MikrotikAuth(loginUrl: 'https://192.168.30.1/login');
  bool loggedIn = await auth.isLoggedIn();

  if (loggedIn) {
    _logger.i("Login Sukses!");
  } else {
    _logger.w("Login Gagal, mungkin username/password salah.");
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Hubungkan ke Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Atur LoginScreen sebagai halaman utama
      home: LoginScreen(),
    );
  }
}

Future<bool> checkInternetAccess() async {
  try {
    // Mencoba melakukan request ke situs publik
    final response = await http.get(Uri.parse('https://www.google.com')).timeout(Duration(seconds: 5));
    return response.statusCode == 200;
  } catch (e) {
    return false; // Gagal terhubung ke internet
  }
}