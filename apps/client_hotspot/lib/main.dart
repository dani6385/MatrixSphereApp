import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'navigation_layout.dart'; // Mengimpor file navigasi yang sudah kita buat
import 'package:provider/provider.dart';
import 'notifiers/quota_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // Langkah 3: Sediakan Notifier ke seluruh aplikasi
    ChangeNotifierProvider(
      create: (context) => QuotaNotifier(),
      child: const MatrixSphereApp(),
    ),
  );
}

class MatrixSphereApp extends StatelessWidget {
  const MatrixSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matrix Sphere',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const NavigationLayout(),
    );
  }
}
