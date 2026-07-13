import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import '../models/product_model.dart';

// Widget untuk menampilkan satu kartu produk
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    final bool isLowStock = product.stock < 5;
    // Mengambil textTheme dari context untuk praktik terbaik
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: kDarkBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLowStock ? kNeonBlue : Colors.transparent,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            product.sku,
            style: textTheme.bodySmall?.copyWith(color: kLightTextPrimary),
          ),
          if (product.ageLimit != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                'Batas Usia: ${product.ageLimit}',
                style: textTheme.bodySmall?.copyWith(color: kWarmOrange),
              ),
            ),
          const Spacer(),
          Text(
            // TODO: Pertimbangkan menggunakan package 'intl' untuk memformat harga dengan benar (misal: Rp 199.000)
            'Rp ${product.price.toStringAsFixed(0)}',
            style: textTheme.bodyLarge?.copyWith(color: kNeonBlue),
          ),
          const SizedBox(height: 4),
          Text(
            'Stok: ${product.stock}',
            style: textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
