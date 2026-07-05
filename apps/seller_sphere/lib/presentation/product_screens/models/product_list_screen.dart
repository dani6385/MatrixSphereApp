import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/presentation/product_screens/providers/product_provider.dart';
import 'package:seller_sphere/presentation/setting_screens/widgets/app_drawer.dart';

/// Layar utama yang menampilkan daftar produk penjual.
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productListNotifierProvider);
    final products = productState.filteredProductIds
        .map((id) => productState.allProducts.firstWhere((p) => p.id == id))
        .toList();

    return Scaffold(
      // Tambahkan drawer di sini
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Produk Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/add-product');
            },
          ),
        ],
      ),
      body: switch (productState.status) {
        ProductListStatus.loading ||
        ProductListStatus.initial =>
          const Center(child: CircularProgressIndicator()),
        ProductListStatus.error => Center(
            child: Text(
                'Gagal memuat produk: ${productState.errorMessage ?? 'Error tidak diketahui'}')),
        ProductListStatus.success => products.isEmpty
            ? const Center(child: Text('Belum ada produk.'))
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    leading: product.imageUrls.isNotEmpty
                        ? Image.network(product.imageUrls.first, width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.image_not_supported, size: 50),
                    title: Text(product.name),
                    subtitle: Text('Stok: ${product.stock}'),
                    trailing: Text('Rp ${product.price.toStringAsFixed(0)}'),
                    onTap: () => context.push('/edit-product/${product.id}'),
                  );
                },
              ),
      },
    );
  }
}