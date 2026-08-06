// lib/features/presentations/inventory/widgets/inventory_list_view.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:go_router/go_router.dart';
import 'inventory_item_card.dart';

/// Widget untuk menampilkan daftar produk inventaris dalam bentuk ListView.
class InventoryListView extends StatelessWidget {
  final List<Product> products;
  const InventoryListView({super.key, required this.products});

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
              Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text('Belum Ada Produk', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Produk yang Anda tambahkan akan muncul di sini untuk manajemen stok.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
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
          // Menambahkan aksi edit, navigasi ke halaman detail produk
          onEdit: () => context.push('/products/${product.id}'),
          // Menambahkan aksi untuk mengelola stok
          onStockManage: () {
            // Di sini kita akan memanggil dialog untuk update stok.
            // Logika ini akan kita tambahkan di ProductService.
            ProductService().showStockUpdateDialog(context, product).then((updated) {
              // Jika stok berhasil diupdate, kita bisa refresh state di sini jika diperlukan.
              // Untuk saat ini, perubahan akan terlihat saat halaman dimuat ulang.
            });
          },
        );
      },
    );
  }
}