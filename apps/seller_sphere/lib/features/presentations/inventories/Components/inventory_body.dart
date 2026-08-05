// lib/features/presentations/inventory/widgets/inventory_body.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'inventory_list_view.dart';

/// Widget yang menjadi body utama dari halaman inventaris.
/// Mengambil data produk dan menampilkannya dalam sebuah daftar.
class InventoryBody extends StatefulWidget {
  const InventoryBody({super.key});

  @override
  State<InventoryBody> createState() => _InventoryBodyState();
}

class _InventoryBodyState extends State<InventoryBody> {
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: _productService.getProductsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const InventoryListView(products: []);
        }
        return InventoryListView(products: snapshot.data!);
      },
    );
  }
}