import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_services/shared_services.dart';
import 'screens/login_page.dart';      // Lokasi LoginPage
import 'widgets/main_widgets.dart';

void main() async {
  // 1. Inisialisasi awal Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inisialisasi Firebase
  await Firebase.initializeApp(options: FirebaseOptions.currentPlatform,);

  // 3. Menjalankan aplikasi dengan MultiProvider di tingkat paling atas
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RealTime()),
      ],
      child: const AdminHome(),
    ),
  );
}

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      // Menggunakan StreamBuilder untuk mengecek status login secara real-time
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Jika sudah login, masuk ke MainLayout (Dashboard)
          if (snapshot.hasData) {
            return const MainLayout();
          }
          // Jika belum login, tampilkan halaman Login
          return const LoginPage();
        },
      ),
    );
  }
}
// Di dalam aplikasi utama (misal: apps/main_app/lib/main.dart)
final getIt = GetIt.instance;

void setupLocator() {
  // Mendaftarkan FirestoreService ke dalam dependency injector
  getIt.registerLazySingleton(() => FirestoreService());
}