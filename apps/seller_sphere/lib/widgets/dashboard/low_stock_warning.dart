import 'package:flutter/material.dart';
import 'package:seller_sphere/models/product.dart';

class LowStockWarning extends StatelessWidget {
  final List<Product> lowStockList;
  final VoidCallback onNavigateToInventory;

  const LowStockWarning({
    super.key,
    required this.lowStockList,
    required this.onNavigateToInventory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer.withAlpha(230), // 0.9 alpha
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: onNavigateToInventory,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(Icons.warning, color: Theme.of(context).colorScheme.error, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Peringatan Stok Menipis! (${lowStockList.length} Produk)",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Ketuk untuk melihat detail barang di inventaris.",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer.withAlpha(204), // 0.8 alpha
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
