import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seller_sphere/presentation/product_screens/providers/product_provider.dart'; // Menggunakan provider dari seller_sphere untuk contoh
import 'widgets/product_recommendation_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Tonton state dari productListNotifierProvider
    final productListState = ref.watch(productListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopSphere Home'),
      ),
      body: switch (productListState.status) {
        ProductListStatus.loading ||
        ProductListStatus.initial =>
          const Center(child: CircularProgressIndicator()),
        ProductListStatus.error => Center(
            child: Text(
                'Gagal memuat produk: ${productListState.errorMessage ?? 'Error tidak diketahui'}')),
        ProductListStatus.success => ProductRecommendationGrid(
            // Tampilkan semua produk yang tersedia
            products: productListState.allProducts,
          ),
      },
    );
  }
}