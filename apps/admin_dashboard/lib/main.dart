import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'main_screen.dart';
import 'login_page.dart';

Future<void> main() async {
  // Memastikan binding widget diinisialisasi sebelum Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Firebase dengan opsi platform saat ini
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const AdminDashboardApp());
}

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),

      // StreamBuilder memantau status login secara real-time
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Jika snapshot memiliki data, berarti user sudah login
          if (snapshot.hasData) {
            return const MainScreen();
          }
          // Jika tidak ada data, user belum login, tampilkan LoginPage
          return const LoginPage();
        },
      ),
    );
  }
}