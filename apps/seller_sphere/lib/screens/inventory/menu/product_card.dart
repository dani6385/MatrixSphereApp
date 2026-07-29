import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

/// Sebuah kartu untuk menampilkan ringkasan informasi produk.
///
/// Menampilkan detail visual seperti gambar, nama, harga, dan stok,
/// serta menyediakan menu aksi untuk mengedit atau menghapus produk.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      clipBehavior: Clip.antiAlias, // Memastikan efek sentuhan tidak keluar dari kartu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Produk
              _buildProductImage(),
              const SizedBox(width: AppSpacing.md),
              // Detail Produk
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Rp ${product.sellingPrice.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: kBrandPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Stok: ${product.stock}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: product.stock <= product.minStockThreshold
                                ? kAlertRed
                                : Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
              // Menu Aksi (Edit/Hapus)
              if (onEdit != null || onDelete != null) _buildActionMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk menampilkan gambar produk.
  Widget _buildProductImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      child: Container(
        width: 70,
        height: 70,
        color: Colors.grey.shade200,
        child: product.imageUrls.isNotEmpty
            ? Image.network(
                product.imageUrls.first,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
              )
            : const Icon(Icons.image, size: 40, color: Colors.grey),
      ),
    );
  }

  /// Widget untuk menampilkan menu popup dengan opsi Edit dan Hapus.
  Widget _buildActionMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.grey),
      onSelected: (value) {
        if (value == 'edit' && onEdit != null) {
          onEdit!();
        } else if (value == 'delete' && onDelete != null) {
          onDelete!();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        if (onEdit != null)
          const PopupMenuItem<String>(
            value: 'edit',
            child: ListTile(leading: Icon(Icons.edit), title: Text('Edit')),
          ),
        if (onDelete != null)
          const PopupMenuItem<String>(
            value: 'delete',
            child: ListTile(
                leading: Icon(Icons.delete, color: kAlertRed),
                title: Text('Hapus', style: TextStyle(color: kAlertRed))),
          ),
      ],
    );
  }
}