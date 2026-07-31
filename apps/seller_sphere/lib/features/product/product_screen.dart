// lib/screens/product_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

import 'widgets/product_body.dart';

/// Sebuah layar untuk menampilkan informasi detail dari satu produk[cite: 6].
class ProductScreen extends StatelessWidget {
  final Product product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String imageUrl)? onImageUploaded;

  const ProductScreen({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
    this.onImageUploaded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        elevation: 1,
        actions: [
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
              tooltip: 'Edit Produk',
            ),
          if (onDelete != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  onDelete!();
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                    value: 'delete', child: Text('Hapus Produk')),
              ],
            ),
        ],
      ),
      body: ProductBody(
        product: product,
        onImageUploaded: onImageUploaded,
      ),
    );
  }
}
