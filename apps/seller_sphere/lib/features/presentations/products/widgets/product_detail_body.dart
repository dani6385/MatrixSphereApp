import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
import 'product_detail_header.dart';
import 'product_detail_info_card.dart';

class ProductDetailBody extends StatelessWidget {
  final Stream<Product?> productStream;

  const ProductDetailBody({
    super.key,
    required this.productStream,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return StreamBuilder<Product?>(
      stream: productStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text(
              'Gagal memuat produk atau produk tidak ditemukan.',
              style: textTheme.bodyLarge,
            ),
          );
        }

        final product = snapshot.data!;

        return SingleChildScrollView(
          padding: AppStyles.defaultScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProductDetailHeader(),
              const SizedBox(height: 24),
              Text(
                product.name,
                style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ProductDetailInfoCard(product: product),
              const SizedBox(height: 24),
              Text('Deskripsi', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                product.description,
                style: textTheme.bodyLarge?.copyWith(color: kDarkTextSecondary),
              ),
            ],
          ),
        );
      },
    );
  }
}