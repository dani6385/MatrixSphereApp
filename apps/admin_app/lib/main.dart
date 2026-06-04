import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_providers.dart'; // Import konfigurasi provider
import 'widgets/monitoring_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Firebase
  await Firebase.initializeApp(options: FirebaseOptions.currentPlatform);

  // 2. Setup Dependency Injection
  setupLocator();

  // 3. Jalankan Aplikasi
  runApp(
    MultiProvider(
      providers: getGlobalProviders(),
      child: const AdminHome(),
    ),
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: getProviders(), // Menggunakan list dari file konfigurasi
      child: const MaterialApp(
        home: AdminWidgets(),
      ),
    );
  }
}
