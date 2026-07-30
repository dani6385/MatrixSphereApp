import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

/// Sebuah layar untuk menampilkan informasi detail dari satu produk.
class ProductScreen extends StatefulWidget {
  final Product product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(String imageUrl)? onImageUploaded;

  const ProductScreen({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
    this.onImageUploaded,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _isUploading = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        elevation: 1,
        actions: [
          if (widget.onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: widget.onEdit,
              tooltip: 'Edit Produk',
            ),
          if (widget.onDelete != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  widget.onDelete!();
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
              widget.product.name,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Harga Produk
            Text(
              'Rp ${widget.product.sellingPrice.toStringAsFixed(0)}',
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
              value: '${widget.product.stock} unit',
              valueColor: widget.product.stock <= widget.product.minStockThreshold ? kAlertRed : null,
            ),
            if (widget.product.sku!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _buildInfoRow(
                context,
                icon: Icons.qr_code_2_outlined,
                label: 'SKU (Kode Barang)',
                value: widget.product.sku!,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.lg),

            // Deskripsi Produk
            Text('Deskripsi Produk', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.product.description?.isNotEmpty == true
                  ? widget.product.description!
                  : 'Tidak ada deskripsi untuk produk ini.',
              style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  /// Fungsi untuk menangani seluruh proses upload gambar.
  Future<void> _handleImageUpload() async {
    // 1. Pilih gambar dari galeri
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return; // Pengguna membatalkan

    setState(() => _isUploading = true);

    try {
      final originalFile = File(pickedImage.path);

      // 2. Kompres gambar
      final XFile? compressedXFile = await compressAndResizeImage(originalFile);
      if (compressedXFile == null) {
        throw Exception('Gagal mengompres gambar.');
      }

      final imageToUpload = File(compressedXFile.path);

      // 3. Unggah ke ImgBB
      final ImageUploadService uploadService = ImageUploadService();
      final String? imageUrl = await uploadService.uploadImageToImgBB(imageToUpload);

      if (imageUrl == null) {
        throw Exception('Gagal mengunggah gambar ke server.');
      }

      // 4. Panggil callback untuk memberitahu parent widget
      widget.onImageUploaded?.call(imageUrl);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar produk berhasil diperbarui!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: kAlertRed),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  /// Widget untuk menampilkan gambar utama produk.
  Widget _buildProductImage(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.lg),
            child: Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey.shade200,
              child: widget.product.imageUrls.isNotEmpty
                  ? Image.network(
                      widget.product.imageUrls.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                    )
                  : const Icon(Icons.image_search, size: 60, color: Colors.grey),
            ),
          ),
          if (_isUploading) const CircularProgressIndicator(),
          if (!_isUploading && widget.onImageUploaded != null)
            Positioned(bottom: 8, right: 8, child: FloatingActionButton.small(onPressed: _handleImageUpload, tooltip: 'Ubah Gambar', child: const Icon(Icons.camera_alt))),
        ],
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