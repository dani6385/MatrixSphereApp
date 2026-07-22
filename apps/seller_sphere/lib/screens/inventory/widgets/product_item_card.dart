import 'package:flutter/material.dart';
import 'package:seller_sphere/models/product.dart';
import 'package:shared_ui/shared_ui.dart';

class ProductItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPrintLabel;
  final VoidCallback onShowQr;
  final String Function(int) formatRupiah;

  const ProductItemCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onPrintLabel,
    required this.onShowQr,
    required this.formatRupiah,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLowStock = product.stock < product.minStockThreshold;
    final theme = Theme.of(context);

    return Card(
      color: isLowStock ? const Color(0xFF281116) : theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isLowStock ? const Color(0xFF991B1B) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Placeholder
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                  ),
                  child: Icon(
                    Icons.image_not_supported,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(width: 12),
                // Product Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          if (isLowStock) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.error, color: kRadiantRose, size: 16),
                          ]
                        ],
                      ),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text(product.category),
                        labelStyle: const TextStyle(fontSize: 10),
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(height: 4),
                      Chip(
                        label: Text("SKU: ${product.sku}"),
                        labelStyle: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                        backgroundColor: kNeonCyan.withValues(alpha: 0.1),
                        side: BorderSide.none,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
                // Action Menu
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: onShowQr, icon: const Icon(Icons.qr_code, color: kNeonCyan, size: 18)),
                    IconButton(onPressed: onPrintLabel, icon: const Icon(Icons.print, color: kNeonCyan, size: 18)),
                    IconButton(onPressed: onEdit, icon: const Icon(Icons.edit, color: kSoftTeal, size: 18)),
                    IconButton(onPressed: onDelete, icon: const Icon(Icons.delete, color: kRadiantRose, size: 18)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatRupiah(product.sellingPrice as int),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Modal: ${formatRupiah(product.purchasePrice as int)}",
                      style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
                // Stock
                _buildStockInfo(isLowStock),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStockInfo(bool isLowStock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            if (isLowStock)
              const Icon(Icons.error, color: kRadiantRose, size: 14)
            else
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(color: kSoftTeal, shape: BoxShape.circle),
              ),
            const SizedBox(width: 6),
            Text(
              "${product.stock} Unit",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isLowStock ? kWarmOrange : kSoftTeal,
              ),
            ),
          ],
        ),
        if (isLowStock)
          Text(
            "Min: ${product.minStockThreshold} Unit",
            style: const TextStyle(fontSize: 9, color: Color(0xFFFCA5A5)),
          ),
      ],
    );
  }
}