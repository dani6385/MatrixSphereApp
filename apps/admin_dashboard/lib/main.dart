import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Tambahkan ini!
import 'main_screen.dart';
import 'login_page.dart'; // Tambahkan ini agar LoginPage terdeteksi
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AdminDashboardApp());
}

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({super.key});

  // ... di dalam kelas AdminDashboardApp ...
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(primarySwatch: Colors.indigo),

      // GANTI BAGIAN INI:
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Jika data login tersedia, arahkan ke MainScreen
          if (snapshot.hasData) {
            return const MainScreen();
          }
          // Jika belum login, arahkan ke halaman Login
          return const LoginPage();
        },
      ),
    );
  }
}
