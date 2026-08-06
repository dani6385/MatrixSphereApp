// lib/features/products/presentation/widgets/product_image_picker.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductImagePicker extends StatelessWidget {
  final XFile? selectedImageFile;
  final String? existingImageUrl;
  final VoidCallback onPickImage;

  const ProductImagePicker({
    super.key,
    this.selectedImageFile,
    this.existingImageUrl,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onPickImage,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: _buildImage(colorScheme),
        ),
      ),
    );
  }

  Widget _buildImage(ColorScheme colorScheme) {
    // Prioritas 1: Tampilkan gambar baru yang dipilih dari file
    if (selectedImageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(selectedImageFile!.path),
          fit: BoxFit.cover,
        ),
      );
    }

    // Prioritas 2: Tampilkan gambar lama dari URL (mode edit)
    if (existingImageUrl != null && existingImageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          existingImageUrl!,
          fit: BoxFit.cover,
          // Tampilkan loading indicator saat gambar dari network dimuat
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
          // Tampilkan ikon error jika gambar gagal dimuat
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 48, color: Colors.grey),
        ),
      );
    }

    // Prioritas 3: Tampilkan placeholder jika tidak ada gambar
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo_outlined, size: 48, color: colorScheme.primary),
        const SizedBox(height: 8),
        Text('Tambah Gambar Produk', style: TextStyle(color: colorScheme.primary)),
      ],
    );
  }
}