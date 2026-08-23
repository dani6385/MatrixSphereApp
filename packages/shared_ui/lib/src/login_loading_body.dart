// lib/screens/login/widgets/login_loading_body.dart
import 'package:flutter/material.dart';

/// Widget sederhana untuk menampilkan indikator loading di tengah layar
class LoginLoadingBody extends StatelessWidget {
  const LoginLoadingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}