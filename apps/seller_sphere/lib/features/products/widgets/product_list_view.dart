import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

import 'product_tile.dart';

class ProductListView extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onEdit;
  final Function(String) onDelete;

  const ProductListView({
    super.key,
    required this.products,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductTile(product: product, onEdit: onEdit, onDelete: onDelete);
      },
    );
  }
}