import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

import '../models/product.dart';

class PinnedProductCard extends StatelessWidget {
  final Product product;
  final String priceLabel;
  const PinnedProductCard({super.key, required this.product, required this.priceLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 135,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: kNeonCyan.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 36,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.shopping_bag, color: kNeonCyan, size: 16),
          ),
          const SizedBox(height: 4),
          Text(product.name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1),
          Text(priceLabel, style: const TextStyle(fontSize: 9, color: kSoftTeal, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(color: kNeonCyan, borderRadius: BorderRadius.circular(4)),
            alignment: Alignment.center,
            child: const Text("TERSEMAT", style: TextStyle(color: kDarkSecondary, fontSize: 8, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}