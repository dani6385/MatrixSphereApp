// lib/features/products/presentation/controllers/add_product_logic.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Diperlukan untuk context.push
import 'package:image_picker/image_picker.dart';
import 'package:shared_services/shared_services.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

/// Handles the business logic for the AddProductScreen.
class AddProductLogic {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController skuController; // Controller baru untuk SKU/Barcode

  // State untuk gambar
  XFile? selectedImageFile;
  String? existingImageUrl;

  // Gunakan ValueNotifier untuk state agar UI bisa bereaksi tanpa passing setState
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> skuValue = ValueNotifier<String?>(null);
  final ValueNotifier<XFile?> selectedImage = ValueNotifier<XFile?>(null);

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
    isLoading.dispose();
    skuValue.dispose();
  }

  /// Scans a barcode/QR code using the dedicated scanner screen and updates the SKU controller.
  Future<void> scanBarcode(BuildContext context) async {
    try {
      // Navigasi ke ScannerScreen dan tunggu hasilnya
      final String? barcodeScanRes = await context.push<String>('/scan-qr');

      if (barcodeScanRes != null && barcodeScanRes.isNotEmpty) {
        skuController.text = barcodeScanRes;
        skuValue.value = barcodeScanRes; // Update ValueNotifier
      }
    } catch (e) {
      logger.e('Gagal memindai: $e'); // Gunakan logger.e untuk error
    }
  }

  /// Picks an image from the gallery, compresses it, and updates the state.
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        // Kompres gambar sebelum di-set ke state
        final compressedFile = await compressAndResizeImage(File(pickedFile.path));
        selectedImage.value = compressedFile; // Update ValueNotifier
      }
    } catch (e) {
      logger.e('Gagal memilih gambar: $e');
    }
  }

  /// Loads existing product data when in edit mode.
  Future<void> loadProductData(String productId, Function(VoidCallback) setState) async {
    isLoading.value = true;
    final product = await _productService.getProductById(productId);
    if (product != null) {
      nameController.text = product.name;
      descriptionController.text = product.description;
      priceController.text = product.price.toString();
      skuController.text = product.sku ?? '';
      existingImageUrl = product.imageUrl;
    }
    isLoading.value = false;
  }

  /// Saves or updates the product.
  Future<void> saveProduct({
    required BuildContext context,
    required bool isEditMode,
    String? productId,
  }) async { // Hapus parameter setStateParent
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      String imageUrl = existingImageUrl ?? '';
      // Jika ada gambar baru yang dipilih, unggah dan perbarui URL-nya
      if (selectedImage.value != null) {
        final uploadedUrl = await _imageUploadService.uploadImageToImgBB(File(selectedImage.value!.path));
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      final priceValue = double.tryParse(priceController.text) ?? 0.0;

      final product = Product(
        id: isEditMode ? productId! : '', // ID akan dibuat oleh Firebase jika baru
        name: nameController.text,
        description: descriptionController.text,
        price: priceValue, // Gunakan nilai harga yang sudah diparsing
        sku: skuController.text.isNotEmpty ? skuController.text : null, // Simpan SKU
        imageUrl: imageUrl, // Gunakan URL gambar yang sudah diunggah
        category: '', // Contoh inisialisasi
        soldCount: 0, // Contoh inisialisasi
        sellingPrice: priceValue, // FIX: Gunakan nilai harga yang sama untuk harga jual
        purchasePrice: 0.0, // Harga beli bisa tetap 0 atau ditambahkan field input baru
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
          final successMessage = isEditMode ? 'Produk berhasil diperbarui' : 'Produk berhasil ditambahkan';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(successMessage)),
          );
          context.pop(true); // Kembali dan beri sinyal sukses
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan produk: $e')),
          );
        }
        logger.e('Gagal menyimpan produk: $e');
        // Tampilkan pesan error ke pengguna jika perlu
      } finally {
        isLoading.value = false;
      }
    }
  }
}