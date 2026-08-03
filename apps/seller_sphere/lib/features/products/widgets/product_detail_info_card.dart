import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class ProductDetailInfoCard extends StatelessWidget {
  final Product product;

  const ProductDetailInfoCard({
    super.key,
    required this.product,
  });

  // Fungsi untuk mendapatkan warna indikator berdasarkan jumlah stok
  Color _getStockIndicatorColor(int stock) {
    if (stock > 100) return kSuccess;
    if (stock > 20) return Kwarning;
    return kError;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final stockColor = _getStockIndicatorColor(product.stock);

    return Card(
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rp ${product.price.toStringAsFixed(0)}',
              style: textTheme.titleLarge?.copyWith(
                color: kSuccess,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: stockColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Stok: ${product.stock}',
                style: textTheme.bodyMedium?.copyWith(
                  color: stockColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}