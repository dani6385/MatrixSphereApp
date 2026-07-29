import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

/// Sebuah layar untuk menampilkan informasi detail dari satu produk.
class ProductScreen extends StatelessWidget {
  final Product product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ProductScreen(
      {super.key, required this.product, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        elevation: 1,
        actions: [
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
              tooltip: 'Edit Produk',
            ),
          if (onDelete != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  onDelete!();
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                    value: 'delete', child: Text('Hapus Produk')),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk
            _buildProductImage(context),
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
            _buildInfoRow(
              context,
              icon: Icons.inventory_2_outlined,
              label: 'Stok Tersedia',
              value: '${product.stock} unit',
              valueColor: product.stock <= product.minStockThreshold ? kAlertRed : null,
            ),
            if (product.sku!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _buildInfoRow(
                context,
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
              product.description?.isNotEmpty == true
                  ? product.description!
                  : 'Tidak ada deskripsi untuk produk ini.',
              style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk menampilkan gambar utama produk.
  Widget _buildProductImage(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        child: Container(
          height: 250,
          width: double.infinity,
          color: Colors.grey.shade200,
          child: product.imageUrls.isNotEmpty
              ? Image.network(
                  product.imageUrls.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                )
              : const Icon(Icons.image, size: 60, color: Colors.grey),
        ),
      ),
    );
  }

  /// Widget helper untuk menampilkan baris informasi (ikon, label, nilai).
  Widget _buildInfoRow(BuildContext context,
      {required IconData icon, required String label, required String value, Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 20),
        const SizedBox(width: AppSpacing.md),
        Text('$label: ', style: Theme.of(context).textTheme.bodyMedium),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: valueColor),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}