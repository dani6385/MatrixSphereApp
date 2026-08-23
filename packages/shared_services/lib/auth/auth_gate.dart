// lib/services/auth_gate.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_navigations/shared_navigations.dart'; // Ganti dengan halaman utama/dashboard Anda
import 'package:shared_screens/shared_screens.dart'; // Ganti dengan halaman utama/dashboard Anda

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. Jika proses pengecekan masih berjalan, tampilkan loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2. Jika pengguna sudah login (Sesi Aktif / Remember Me berjalan)
        if (snapshot.hasData && snapshot.data != null) {
          // Anda bisa mengarahkan langsung ke halaman utama Anda
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AppNavigation.goToTab(context, AppRoutes.caseOScreen); // Ganti dengan halaman utama/dashboard Anda
          });
          
          // Kembalikan loading sementara proses perpindahan halaman berjalan
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // 3. Jika belum login atau sudah logout, arahkan ke halaman Login
        return const LoginScreen();
      },
    );
  }
}
