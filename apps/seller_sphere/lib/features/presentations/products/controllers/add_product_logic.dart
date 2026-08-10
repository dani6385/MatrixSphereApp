// lib/features/products/presentation/controllers/add_product_logic.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_services/shared_services.dart';
import 'product_form_controllers.dart';
import 'product_media_handler.dart';
import 'product_save_handler.dart';

/// Handles the business logic for the AddProductScreen.
class AddProductLogic {
  final ProductFormControllers formControllers = ProductFormControllers();
  final ProductMediaHandler mediaHandler = ProductMediaHandler();
  final ProductSaveHandler saveHandler = ProductSaveHandler();
  final ProductService _productService = ProductService();

  String? existingImageUrl;

  // Getter singkat untuk mempermudah akses dari UI
  GlobalKey<FormState> get formKey => formControllers.formKey;
  TextEditingController get nameController => formControllers.nameController;
  TextEditingController get descriptionController => formControllers.descriptionController;
  TextEditingController get priceController => formControllers.priceController;
  TextEditingController get skuController => formControllers.skuController;
  ValueNotifier<bool> get isLoading => formControllers.isLoading;
  XFile? get selectedImageFile => mediaHandler.selectedImage.value;

  void initControllers() {
    formControllers.init();
    mediaHandler.selectedImage.addListener(() {}); 
  }

  void disposeControllers() {
    formControllers.dispose();
    mediaHandler.dispose();
  }

  Future<void> scanBarcode(BuildContext context) async {
    await mediaHandler.scanBarcode(context, formControllers.skuController, formControllers.skuValue);
  }

  Future<void> pickImage(ImageSource source) async {
    await mediaHandler.pickImage(source);
  }

  Future<void> loadProductData(String productId) async {
    formControllers.isLoading.value = true;
    final product = await _productService.getProductById(productId);
    if (product != null) {
      formControllers.nameController.text = product.name;
      formControllers.descriptionComponentText(product.description); // atau .text
      formControllers.descriptionController.text = product.description; 
      formControllers.priceController.text = product.sellingPrice.toString(); // Assuming 'unitPrice' is the correct field name based on common product models
      formControllers.skuController.text = product.sku ?? '';
      existingImageUrl = product.imageUrl;
    }
    formControllers.isLoading.value = false;
  }

  Future<void> saveProduct({
    required BuildContext context,
    required bool isEditMode,
    String? productId,
  }) async {
    await saveHandler.saveProduct(
      context: context,
      isEditMode: isEditMode,
      productId: productId,
      formKey: formControllers.formKey,
      nameController: formControllers.nameController,
      descriptionController: formControllers.descriptionController,
      priceController: formControllers.priceController,
      skuController: formControllers.skuController,
      existingImageUrl: existingImageUrl,
      selectedImageFile: mediaHandler.selectedImage.value,
      isLoading: formControllers.isLoading,
    );
  }
}