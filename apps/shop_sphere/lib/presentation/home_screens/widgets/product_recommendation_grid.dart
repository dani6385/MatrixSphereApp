import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/shared_seller.dart'; // Menggunakan model dari seller_sphere untuk contoh
import 'package:shop_sphere/presentation/cart_screens/providers/cart_provider.dart';

class ProductRecommendationGrid extends StatelessWidget {
  final List<Product> products;

  const ProductRecommendationGrid({
    required this.products,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    if (products.isEmpty) {
      return const Center(child: Text('Tidak ada produk untuk ditampilkan.'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.65,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.network(
                  product.imageUrls.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currencyFormatter.format(product.price),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text('Keranjang'),
                  onPressed: () {
                    // Menggunakan context.read dari package:provider untuk memanggil metode
                    context.read<CartProvider>().addItem(
                          productId: product.id,
                          name: product.name,
                          price: product.price.toDouble(),
                          imageUrl: product.imageUrls.first,
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} ditambahkan ke keranjang!')),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}