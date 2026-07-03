import 'package:flutter/material.dart';
// Impor widget kartu produk dari shared_ui
import 'package:shared_ui/shared_ui.dart'; 

class ProductRecommendationGrid extends StatelessWidget {
  const ProductRecommendationGrid({super.key});

  // Data dummy produk
  final List<Map<String, dynamic>> _products = const [
    {
      'id': '1',
      'name': 'Wireless Headphone Alpha',
      'price': 1500000,
      'imageUrl': 'assets/images/product1.jpg',
      'rating': 4.5,
    },
    {
      'id': '2',
      'name': 'Smart Watch Series 5',
      'price': 2200000,
      'imageUrl': 'assets/images/product2.jpg',
      'rating': 4.8,
    },
     {
      'id': '3',
      'name': 'Gaming Mouse X10',
      'price': 550000,
      'imageUrl': 'assets/images/product3.jpg',
      'rating': 4.2,
    },
    {
      'id': '4',
      'name': 'Mechanical Keyboard Z',
      'price': 1800000,
      'imageUrl': 'assets/images/product4.jpg',
      'rating': 4.7,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
            final product = _products[index];
            // Gunakan widget kartu produk yang modular dari shared_ui
            return ProductCard(
              name: product['name'],
              price: product['price'],
              imageUrl: product['imageUrl'],
              rating: product['rating'],
              onTap: () {
                // Navigasi ke detail produk
              },
            );
          },
          childCount: _products.length,
        ),
      ),
    );
  }
}