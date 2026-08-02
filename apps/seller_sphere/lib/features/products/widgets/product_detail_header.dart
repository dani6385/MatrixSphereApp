// lib/screens/products/widgets/product_detail_header.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ProductDetailHeader extends StatelessWidget {
  const ProductDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.image, size: 80, color: kDarkTextSecondary),
      ),
    );
  }
}