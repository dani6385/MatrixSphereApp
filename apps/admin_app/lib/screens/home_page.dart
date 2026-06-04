import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder<User?>(
        // Mendengarkan perubahan status login dari Firebase
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Jika data ada, berarti user sudah login
          if (snapshot.hasData) {
            return const MainLayout(); // Tampilkan Dashboard
          }
          // Jika tidak ada data, tampilkan halaman Login
          return const LoginPage();
        },
      ),
    );
  }
}
