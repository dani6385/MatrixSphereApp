import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../packages/shared_firebase/firebase_options.dart';
import 'navigation_layout.dart'; // Mengimpor file navigasi yang sudah kita buat

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MatrixSphereApp());
}

class MatrixSphereApp extends StatelessWidget {
  const MatrixSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug di pojok kanan
      title: 'Matrix Sphere',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true, // Menggunakan desain modern Material 3
        fontFamily: 'Roboto', // Kamu bisa mengganti font di sini nantinya
      ),
      // Menghubungkan ke file navigasi sebagai halaman utama
      home: const NavigationLayout(),
    );
  }
}
