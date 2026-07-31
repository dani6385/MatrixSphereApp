import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final Function(Product) onEdit;
  final Function(String) onDelete;

  const ProductTile({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: ListTile(
        leading: const Icon(Icons.inventory_2_outlined, color: kLightBackground),
        title: Text(product.name,
            style: AppStyles.primaryTitle(Theme.of(context).textTheme)),
        subtitle: Text(
            'Harga: Rp ${product.price.toStringAsFixed(0)} | Stok: ${product.stock}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: kLightTextSecondary),
              onPressed: () => onEdit(product),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: kAlertRed),
              onPressed: () => onDelete(product.name),
            ),
          ],
        ),
      ),
    );
  }
}