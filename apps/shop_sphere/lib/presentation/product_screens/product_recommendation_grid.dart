import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
// Impor widget kartu produk dari shared_ui
import 'package:shop_sphere/presentation/product_screens/provider/product_provider.dart';
import 'package:shop_sphere/presentation/cart_screens/providers/cart_provider.dart';
import 'package:shared_ui/shared_ui.dart'; 

class ProductRecommendationGrid extends StatelessWidget {
  const ProductRecommendationGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final products = productProvider.products;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 kolom
          childAspectRatio: 0.75, // Rasio lebar:tinggi kartu
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            // Bungkus ProductCard dengan Hero widget untuk animasi transisi.
            // Tag harus unik dan sama dengan yang ada di ProductDetailScreen.
            return Hero(
              tag: product.id,
              child: ProductCard(
                name: product.name,
                price: product.price,
                imageUrl: product.imageUrl,
                rating: product.rating,
                onTap: () {
                  context.push('/product/${product.id}');
                },
                onAddToCart: () {
                  cartProvider.addItem(
                    productId: product.id,
                    name: product.name,
                    price: product.price,
                    imageUrl: product.imageUrl,
                  );
                  // Tampilkan notifikasi singkat
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} ditambahkan ke keranjang!')),
                  );
                },
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}