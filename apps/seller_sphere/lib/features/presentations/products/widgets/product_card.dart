<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap; // <-- TAMBAHKAN CALLBACK INI

  const ProductCard({
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
    final indicatorColor = _getStockIndicatorColor(product.stock);

    return Card(
      color: context.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        onTap: onTap, // <-- PASANG AKSI KLIK DI SINI
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(product.name, style: context.textTheme.titleMedium),
        subtitle: Text(
          'ID: ${product.id}',
          style: context.textTheme.bodySmall
          ?.copyWith(color: kDarkTextSecondary),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: indicatorColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Stok: ${product.stock}',
            style: context.textTheme.bodySmall?.copyWith(
              color: indicatorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
<<<<<<< HEAD
=======
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap; // <-- TAMBAHKAN CALLBACK INI

  const ProductCard({
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
    final indicatorColor = _getStockIndicatorColor(product.stock);

    return Card(
      color: context.cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        onTap: onTap, // <-- PASANG AKSI KLIK DI SINI
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(product.name, style: context.textTheme.titleMedium),
        subtitle: Text(
          'ID: ${product.id}',
          style: context.textTheme.bodySmall
          ?.copyWith(color: kDarkTextSecondary),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: indicatorColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Stok: ${product.stock}',
            style: context.textTheme.bodySmall?.copyWith(
              color: indicatorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
