// lib/screens/shop/widgets/shop_id_card.dart
import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ShopIdCard extends StatelessWidget {
  final String shopId;
  final VoidCallback onCopyPressed;

  const ShopIdCard({
    super.key,
    required this.shopId,
    required this.onCopyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ID Toko', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(child: Text(shopId, style: AppStyles.bodyLarge)),
              IconButton(
                icon: const Icon(Icons.copy_outlined, size: 20),
                onPressed: onCopyPressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}