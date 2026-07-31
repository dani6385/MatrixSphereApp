// lib/screens/widgets/product_image_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class ProductImageView extends StatefulWidget {
  final Product product;
  final Function(String imageUrl)? onImageUploaded;

  const ProductImageView({
    super.key,
    required this.product,
    this.onImageUploaded,
  });

  @override
  State<ProductImageView> createState() => _ProductImageViewState();
}

class _ProductImageViewState extends State<ProductImageView> {
  bool _isUploading = false;

  /// Fungsi untuk menangani seluruh proses upload gambar.
  Future<void> _handleImageUpload() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    setState(() => _isUploading = true);

    try {
      final originalFile = File(pickedImage.path);

      final XFile? compressedXFile = await compressAndResizeImage(originalFile);
      if (compressedXFile == null) {
        throw Exception('Gagal mengompres gambar.');
      }

      final imageToUpload = File(compressedXFile.path);

      final ImageUploadService uploadService = ImageUploadService();
      final String? imageUrl = await uploadService.uploadImageToImgBB(imageToUpload);

      if (imageUrl == null) {
        throw Exception('Gagal mengunggah gambar ke server.');
      }

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

  @override
  Widget build(BuildContext context) {
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
            Positioned(
              bottom: 8,
              right: 8,
              child: FloatingActionButton.small(
                onPressed: _handleImageUpload,
                tooltip: 'Ubah Gambar',
                child: const Icon(Icons.camera_alt),
              ),
            ),
        ],
      ),
    );
  }
}