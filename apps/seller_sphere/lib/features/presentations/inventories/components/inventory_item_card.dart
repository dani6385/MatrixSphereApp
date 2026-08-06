// lib/features/presentations/inventory/widgets/inventory_item_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/features/presentations/products/product_detail_screen.dart';
import 'package:seller_sphere/navigations/app_extractor.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/theme/app_colors.dart';

/// Kartu untuk menampilkan satu item produk dalam daftar inventaris.
class InventoryItemCard extends StatelessWidget {
  final Product product;

  const InventoryItemCard(
      {super.key,
      required this.product,
      required Future<Object?> Function() onEdit,
      required Null Function() onStockManage});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          backgroundImage:
              (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                  ? NetworkImage(product.imageUrl!)
                  : null,
          child: (product.imageUrl == null || product.imageUrl!.isEmpty)
              ? const Icon(Icons.shopping_bag_outlined)
              : null,
        ),
        title: Text(product.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(currencyFormatter.format(product.price)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${product.stock}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: product.stock < 10
                        ? kAlertRed
                        : Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text('Stok', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        onTap: () {
          // Navigasi ke halaman detail produk saat kartu diketuk.
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (context) => const ProductDetailScreen(
                productId: '',
              ),
            ),
          );
        },
      ),
    );
  }
}
