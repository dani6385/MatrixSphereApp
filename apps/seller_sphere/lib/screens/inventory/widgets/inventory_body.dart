import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

import 'inventory_dialogs.dart';
import 'product_list_view.dart';

class InventoryBody extends StatelessWidget {
  final DatabaseReference productsRef;
  final Future<void> Function(Product productData) onSaveProduct;
  final Future<void> Function(String productName) onDeleteProduct;

  const InventoryBody({
    super.key,
    required this.productsRef,
    required this.onSaveProduct,
    required this.onDeleteProduct,
  });

  void _showProductFormDialog(BuildContext context, {Product? product}) {
    showProductFormModal(
        context: context, product: product, onSaveCallback: onSaveProduct);
  }

  Future<void> _confirmDeleteProduct(
      BuildContext context, String productName) async {
    showDeleteConfirmationDialog(
      context: context,
      productName: productName,
      onDeleteConfirmed: onDeleteProduct,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: productsRef.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final productsData = snapshot.data?.snapshot.value;
        if (productsData == null ||
            (productsData is Map && productsData.isEmpty)) {
          return const Center(child: Text('Belum ada produk.'));
        }

        final productsMap =
            Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
        final List<Product> products = productsMap.entries.map((entry) {
          return Product.fromMap(
              Map<String, dynamic>.from(entry.value), entry.key);
        }).toList();

        return ProductListView(
          products: products,
          onEdit: (product) => _showProductFormDialog(context, product: product),
          onDelete: (productName) => _confirmDeleteProduct(context, productName),
        );
      },
    );
  }
}