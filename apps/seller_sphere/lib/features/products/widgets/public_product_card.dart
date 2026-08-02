import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class PublicProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap; // <-- TAMBAHKAN CALLBACK INI

  const PublicProductCard({
    super.key,
    required this.product,
    required this.onTap, // <-- WAJIB DIISI SAAT DIPANGGIL
  });

  Color _getStockIndicatorColor(int stock) {
    if (stock > 100) return kSuccess;
    if (stock > 20) return Kwarning;
    return kError;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final indicatorColor = _getStockIndicatorColor(product.stock);

    return Card(
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        onTap: onTap, // <-- PASANG AKSI KLIK DI SINI
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(product.name, style: textTheme.titleMedium),
        subtitle: Text(
          'ID: ${product.id}',
          style: textTheme.bodySmall?.copyWith(color: kDarkTextSecondary),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: indicatorColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Stok: ${product.stock}',
            style: textTheme.bodyMedium?.copyWith(
              color: indicatorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}