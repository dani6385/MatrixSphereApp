// lib/screens/login/widgets/login_header.dart
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.storefront_outlined,
          size: 80,
          color: context.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Selamat Datang Kembali!',
          textAlign: TextAlign.center,
          style: AppStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Masuk untuk melanjutkan ke Seller Sphere',
          textAlign: TextAlign.center,
          style: AppStyles.bodyMedium,
        ),
      ],
    );
  }
}