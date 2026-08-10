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
    
    final stockColor = _getStockIndicatorColor(product.stock);

    return Card(
      color: context.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rp ${product.unitPrice.toStringAsFixed(0)}',
              style: AppStyles.headlineMedium.copyWith(
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
                style: AppStyles.bodyLarge.copyWith(
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