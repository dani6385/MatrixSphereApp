// lib/screens/home/widgets/home_welcome_header.dart
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class HomeWelcomeHeader extends StatelessWidget {
  const HomeWelcomeHeader({super.key, required this.sellerName});
  final String sellerName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selamat Datang Kembali,',
          style: AppStyles.titleMedium?.copyWith(color: kDarkTextSecondary),
        ),
        Text(
          sellerName,
          style: AppStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
