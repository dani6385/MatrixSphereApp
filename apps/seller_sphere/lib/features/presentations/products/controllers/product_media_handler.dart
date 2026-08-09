// lib/features/products/presentation/controllers/product_media_handler.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_services/shared_services.dart';

final Logger _logger = Logger();

class ProductMediaHandler {
  final ImagePicker _picker = ImagePicker();
  final ValueNotifier<XFile?> selectedImage = ValueNotifier<XFile?>(null);

  /// Memindai barcode dan memperbarui SKU controller
  Future<void> scanBarcode(BuildContext context, TextEditingController skuController, ValueNotifier<String?> skuValue) async {
    try {
      final String? barcodeScanRes = await context.push<String>('/scan-qr');

      if (barcodeScanRes != null && barcodeScanRes.isNotEmpty) {
        skuController.text = barcodeScanRes;
        skuValue.value = barcodeScanRes;
      }
    } catch (e) {
      _logger.e('Gagal memindai: $e');
    }
  }

  /// Memilih dan mengompres gambar
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final compressedFile = await compressAndResizeImage(File(pickedFile.path));
        selectedImage.value = compressedFile;
      }
    } catch (e) {
      _logger.e('Gagal memilih gambar: $e');
    }
  }

  void dispose() {
    selectedImage.dispose();
  }
}