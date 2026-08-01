// lib/screens/products/widgets/public_product_item.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class PublicProductItem extends StatelessWidget {
  final Product product;

  const PublicProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kDarkSecondary,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          product.name,
          style: const TextStyle(color: kLightTextPrimary),
        ),
        subtitle: Text(
          'Stok: ${product.stock}',
          style: const TextStyle(color: kLightTextSecondary),
        ),
        trailing: Text(
          'Rp ${product.sellingPrice.toStringAsFixed(0)}',
          style: const TextStyle(
            color: kBrandPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}