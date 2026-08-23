import 'package:flutter/material.dart';

import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

/// Halaman Login Utama Aplikasi
/// 
/// File ini dipecah menjadi beberapa sub-komponen di dalam direktori `widgets/`:
/// - `LoginHeader`: Logo, Judul, dan Subjudul.
/// - `LoginForm`: Input Form, Remember Me, Error Banner, dan Tombol Masuk.
/// - `LoginErrorBanner`: Banner pesan kesalahan interaktif.
/// - `LoginRememberMe`: Widget checkbox opsi ingat akun.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LoginHeader(),
                  SizedBox(height: 24),
                  LoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
