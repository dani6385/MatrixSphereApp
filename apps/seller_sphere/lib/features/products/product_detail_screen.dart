import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';

class ProductDetailScreen extends StatelessWidget {
  final String shopId;
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.shopId,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: kDarkSecondary,
        leading: IconButton(
          // Gunakan canPop untuk kembali ke halaman sebelumnya atau ke home jika tidak ada
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ini adalah halaman untuk produk:',
                  style: TextStyle(color: kLightTextSecondary)),
              const SizedBox(height: 16),
              SelectableText('Shop ID: $shopId',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kLightTextPrimary)),
              SelectableText('Product ID: $productId',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kLightTextPrimary)),
              const SizedBox(height: 24),
              const Text(
                  'Di sini Anda bisa mengambil data produk dari database menggunakan ID di atas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kLightTextSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
