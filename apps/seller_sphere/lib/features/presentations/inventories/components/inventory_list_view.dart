// lib/features/presentations/inventory/widgets/inventory_list_view.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
//import 'package:seller_sphere/navigations/app_extractor.dart';
import 'inventory_item_card.dart';

/// Widget untuk menampilkan daftar produk inventaris dalam bentuk ListView.
class InventoryListView extends StatelessWidget {
  final List<Product> products;
  final Function(Product product, int newStock)
      onStockUpdateCallback; // Changed signature

  const InventoryListView({
    super.key,
    required this.products,
    required this.onStockUpdateCallback,
  });

  @override
  Widget build(BuildContext context) {
    // Jika tidak ada produk, tampilkan pesan di tengah.
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text('Belum Ada Produk',
                  style: AppStyles.headlineMedium
                      .copyWith(color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              Text(
                'Produk yang Anda tambahkan akan muncul di sini untuk manajemen stok.',
                textAlign: TextAlign.center,
                style:
                    AppStyles.bodyMedium.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    // Mengurutkan produk berdasarkan nama untuk memudahkan pencarian
    final sortedProducts = List<Product>.from(products)
      ..sort((a, b) => a.name.compareTo(b.name));

    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: sortedProducts.length,
      itemBuilder: (context, index) {
        final product = sortedProducts[index];
        return InventoryItemCard(
          product: product,
          onStockUpdate: onStockUpdateCallback, // Pass the new callback
        );
      },
    );
  }
}
