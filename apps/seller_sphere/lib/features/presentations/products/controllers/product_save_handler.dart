// lib/features/products/presentation/controllers/product_save_handler.dart

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:shared_services/shared_services.dart';

final Logger _logger = Logger();

class ProductSaveHandler {
  final ProductService _productService = ProductService();
  final ImageUploadService _imageUploadService = ImageUploadService();

  /// Menyimpan atau memperbarui produk ke database
  Future<void> saveProduct({
    required BuildContext context,
    required bool isEditMode,
    String? productId,
    required GlobalKey<FormState> formKey,
    required TextEditingController nameController,
    required TextEditingController descriptionController,
    required TextEditingController priceController,
    required TextEditingController skuController,
    required String? existingImageUrl,
    required XFile? selectedImageFile,
    required ValueNotifier<bool> isLoading,
  }) async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      String imageUrl = existingImageUrl ?? '';
      if (selectedImageFile != null) {
        final uploadedUrl = await _imageUploadService.uploadImageToImgBB(File(selectedImageFile.path));
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      final priceValue = double.tryParse(priceController.text) ?? 0.0;

      final product = Product(
        id: isEditMode ? productId! : '',
        name: nameController.text,
        description: descriptionController.text,
        price: priceValue,
        sku: skuController.text.isNotEmpty ? skuController.text : null,
        imageUrl: imageUrl,
        category: '',
        soldCount: 0,
        sellingPrice: priceValue,
        purchasePrice: 0.0,
        stock: 0,
        shopId: '',
      );

      try {
        if (isEditMode) {
          await _productService.updateProduct(product);
        } else {
          await _productService.addProduct(product);
        }
        if (context.mounted) {
          final successMessage = isEditMode ? 'Produk berhasil diperbarui' : 'Produk berhasil ditambahkan';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(successMessage)),
          );
          context.pop(true);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan produk: $e')),
          );
        }
        _logger.e('Gagal menyimpan produk: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }
}