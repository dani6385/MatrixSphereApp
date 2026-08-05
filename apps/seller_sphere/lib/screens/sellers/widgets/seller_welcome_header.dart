
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart'; // Impor AppStyles

class SellerWelcomeHeader extends StatelessWidget {
  final String sellerName;

  const SellerWelcomeHeader({
    super.key,
    required this.sellerName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selamat Datang,',
          style: AppStyles.bodyMedium,
        ),
        Text(
          sellerName,
          style: AppStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}