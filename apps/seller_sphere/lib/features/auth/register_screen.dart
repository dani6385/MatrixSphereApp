import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ini adalah halaman placeholder. Anda bisa mengembangkannya nanti.
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        title: const Text('Daftar Akun Baru'),
        backgroundColor: kDarkSecondary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_add_alt_1, size: 80, color: kBrandPrimary),
              SizedBox(height: 20),
              Text(
                'Halaman Registrasi',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kLightTextPrimary),
              ),
              SizedBox(height: 10),
              Text('Fitur ini sedang dalam pengembangan.', textAlign: TextAlign.center, style: TextStyle(color: kLightTextSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}