// lib/screens/products/widgets/public_product_Body.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
import '../widgets/public_product_item.dart';

class PublicProductBody extends StatelessWidget {
  final Future<List<Product>> productsFuture;

  const PublicProductBody({
    super.key,
    required this.productsFuture,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Gagal memuat produk: ${snapshot.error}',
              style: const TextStyle(color: kLightTextSecondary),
            ),
          );
        }

        final products = snapshot.data;

        if (products == null || products.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada produk yang tersedia.',
              style: TextStyle(color: kLightTextSecondary),
            ),
          );
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return PublicProductItem(product: products[index]);
          },
        );
      },
    );
  }
}