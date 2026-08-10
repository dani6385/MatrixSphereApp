import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import GoRouter
// import 'package:seller_sphere/features/presentations/products/product_detail_screen.dart'; // Tidak perlu diimpor langsung di sini, rutenya yang digunakan
import 'package:shared_services/shared_services.dart';
import 'public_product_card.dart';

class PublicProductList extends StatelessWidget {
  final Stream<List<Product>> productsStream;

  const PublicProductList({
    super.key,
    required this.productsStream,
    
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: productsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Belum ada produk di gudang.'));
        }

        final products = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return PublicProductCard(
              product: product,
              onTap: () {
                // Implementasi navigasi ke ProductDetailScreen
                context.push(
                    '/products/${product.id}'); // Navigasi ke rute detail produk dengan ID
              },
            );
          },
        );
      },
    );
  }
}
