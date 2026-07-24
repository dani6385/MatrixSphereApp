import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/screens/inventory/providers/inventory_provider.dart';

import 'package:shared_ui/shared_ui.dart';

class LowStockWarning extends StatelessWidget {
  const LowStockWarning({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryProvider>(
      builder: (context, provider, child) {
        final lowStockCount = provider.lowStockCount;
        if (lowStockCount == 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kWarmOrange.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning, color: kWarmOrange, size: 16),
              const SizedBox(width: 6),
              Text(
                "Ada $lowStockCount produk perlu re-stock segera!",
                style: const TextStyle(
                    fontSize: 11,
                    color: kWarmOrange,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }
}
