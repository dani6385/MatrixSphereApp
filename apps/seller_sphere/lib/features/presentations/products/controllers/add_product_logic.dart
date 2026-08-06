// lib/features/products/presentation/controllers/add_product_logic.dart

import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Diperlukan untuk context.push
import 'package:image_picker/image_picker.dart';
import 'package:shared_services/shared_services.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

/// Handles the business logic for the AddProductScreen.
class AddProductLogic {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController skuController; // Controller baru untuk SKU/Barcode

  // State untuk gambar
  XFile? selectedImageFile;
  String? existingImageUrl;

  bool isLoading = false;
  final ProductService _productService = ProductService();
  final ImageUploadService _imageUploadService = ImageUploadService();
  final ImagePicker _picker = ImagePicker();

  /// Initializes all the text controllers.
  void initControllers() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    skuController = TextEditingController(); // Inisialisasi controller baru
  }

  /// Disposes all controllers to prevent memory leaks.
  void disposeControllers() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    skuController.dispose(); // Jangan lupa dispose controller baru
  }

  /// Scans a barcode/QR code using the dedicated scanner screen and updates the SKU controller.
  Future<void> scanBarcode(BuildContext context, Function(VoidCallback) setState) async {
    try {
      // Navigasi ke ScannerScreen dan tunggu hasilnya
      final String? barcodeScanRes = await context.push<String>('/scan-qr');

      if (barcodeScanRes != null && barcodeScanRes.isNotEmpty) {
        setState(() {
          skuController.text = barcodeScanRes;
        });
      }
    } catch (e) {
      logger.e('Gagal memindai: $e'); // Gunakan logger.e untuk error
    }
  }

  /// Picks an image from the gallery, compresses it, and updates the state.
  Future<void> pickImage(ImageSource source, Function(VoidCallback) setState) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        // Kompres gambar sebelum di-set ke state
        final compressedFile = await compressAndResizeImage(File(pickedFile.path));
        setState(() {
          selectedImageFile = compressedFile;
        });
      }
    } catch (e) {
      logger.e('Gagal memilih gambar: $e');
    }
  }

  /// Loads existing product data when in edit mode.
  Future<void> loadProductData(String productId, Function(VoidCallback) setState) async {
    setState(() => isLoading = true);
    final product = await _productService.getProductById(productId);
    if (product != null) {
      nameController.text = product.name;
      descriptionController.text = product.description;
      priceController.text = product.price.toString();
      skuController.text = product.sku ?? '';
      existingImageUrl = product.imageUrl;
    }
    setState(() => isLoading = false);
  }

  /// Saves or updates the product.
  Future<void> saveProduct({
    required BuildContext context,
    required bool isEditMode,
    String? productId,
    required Function(VoidCallback) setStateParent,
  }) async {
    if (formKey.currentState!.validate()) {
      setStateParent(() => isLoading = true);

      String imageUrl = existingImageUrl ?? '';
      // Jika ada gambar baru yang dipilih, unggah dan perbarui URL-nya
      if (selectedImageFile != null) {
        final uploadedUrl = await _imageUploadService.uploadImageToImgBB(File(selectedImageFile!.path));
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      final product = Product(
        id: isEditMode ? productId! : '', // ID akan dibuat oleh Firebase jika baru
        name: nameController.text,
        description: descriptionController.text,
        price: double.tryParse(priceController.text) ?? 0.0,
        sku: skuController.text.isNotEmpty ? skuController.text : null, // Simpan SKU
        // Inisialisasi field lain jika ada
        imageUrl: imageUrl, // Gunakan URL gambar yang sudah diunggah
        category: '', // Contoh inisialisasi
        soldCount: 0, // Contoh inisialisasi
        sellingPrice: 0.0, // Mengubah null menjadi 0.0 karena tipe double tidak boleh null
        purchasePrice: 0.0, // Mengubah null menjadi 0.0 karena tipe double tidak boleh null
        stock: 0, // Dihapus dari form, di-set default 0 saat produk dibuat
        shopId: '', // Contoh inisialisasi
      );

      try {
        if (isEditMode) {
          await _productService.updateProduct(product);
        } else {
          await _productService.addProduct(product);
        }
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menyimpan produk: $e')),
          );
        }
      } catch (e) {
        logger.e('Gagal menyimpan produk: $e');
        // Tampilkan pesan error ke pengguna jika perlu
      } finally {
        setStateParent(() => isLoading = false);
      }
    }
  }
}