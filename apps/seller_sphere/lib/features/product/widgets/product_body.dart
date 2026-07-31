// lib/screens/widgets/product_body.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

import 'product_image_view.dart';
import 'product_info_row.dart';

class ProductBody extends StatelessWidget {
  const ProductBody({
    super.key,
    required this.product,
    this.onImageUploaded,
  });

  final Product product;
  final Function(String imageUrl)? onImageUploaded;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          ProductImageView(
            product: product,
            onImageUploaded: onImageUploaded,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Nama Produk
          Text(
            product.name,
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Harga Produk
          Text(
            'Rp ${product.sellingPrice.toStringAsFixed(0)}',
            style: textTheme.titleLarge?.copyWith(
              color: kBrandPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.md),

          // Info Stok dan SKU
          ProductInfoRow(
            icon: Icons.inventory_2_outlined,
            label: 'Stok Tersedia',
            value: '${product.stock} unit',
            valueColor: product.stock <= product.minStockThreshold ? kAlertRed : null,
          ),
          if (product.sku?.isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.md),
            ProductInfoRow(
              icon: Icons.qr_code_2_outlined,
              label: 'SKU (Kode Barang)',
              value: product.sku!,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.lg),

          // Deskripsi Produk
          Text('Deskripsi Produk', style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Text(
            product.description.isNotEmpty == true
                ? product.description
                : 'Tidak ada deskripsi untuk produk ini.',
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}