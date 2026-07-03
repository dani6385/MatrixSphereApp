import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_sphere/providers/cart_provider.dart';
import 'package:shared_ui/shared_ui.dart';

// In a real app, this data would come from a provider or API, not hardcoded.
const List<Map<String, dynamic>> _allProducts = [
  {
    'id': '1',
    'name': 'Wireless Headphone Alpha',
    'price': 1500000.0,
    'imageUrl': 'assets/images/product1.jpg',
    'rating': 4.5,
    'description':
        'Rasakan kebebasan audio nirkabel sejati dengan Wireless Headphone Alpha. Kualitas suara jernih, bass mendalam, dan daya tahan baterai hingga 20 jam. Desain ergonomis untuk kenyamanan sepanjang hari.'
  },
  {
    'id': '2',
    'name': 'Smart Watch Series 5',
    'price': 2200000.0,
    'imageUrl': 'assets/images/product2.jpg',
    'rating': 4.8,
    'description':
        'Tetap terhubung dan sehat dengan Smart Watch Series 5. Lacak aktivitas Anda, monitor detak jantung, dan terima notifikasi langsung di pergelangan tangan Anda. Tahan air hingga 50 meter.'
  },
  {
    'id': '3',
    'name': 'Gaming Mouse X10',
    'price': 550000.0,
    'imageUrl': 'assets/images/product3.jpg',
    'rating': 4.2,
    'description':
        'Dominasi permainan dengan Gaming Mouse X10. Sensor optik presisi tinggi, tombol yang dapat diprogram, dan pencahayaan RGB yang dapat disesuaikan untuk pengalaman gaming terbaik.'
  },
  {
    'id': '4',
    'name': 'Mechanical Keyboard Z',
    'price': 1800000.0,
    'imageUrl': 'assets/images/product4.jpg',
    'rating': 4.7,
    'description':
        'Tingkatkan pengalaman mengetik dan bermain game Anda dengan Mechanical Keyboard Z. Switch mekanis yang responsif, konstruksi aluminium yang kokoh, dan layout yang ringkas.'
  },
];

class ProductDetailScreen extends StatelessWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    // Find the product from the dummy list.
    final product = _allProducts.firstWhere(
      (p) => p['id'] == productId,
      orElse: () => {},
    );

    if (product.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Produk tidak ditemukan.')),
      );
    }

    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product['imageUrl'],
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox(height: 300, child: Icon(Icons.image_not_supported)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${product['price'].toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['description'],
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            cart.addItem(
              productId: product['id'],
              name: product['name'],
              price: product['price'],
              imageUrl: product['imageUrl'],
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${product['name']} ditambahkan ke keranjang!'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Tambah ke Keranjang', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}