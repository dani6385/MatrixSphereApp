// lib/features/products/presentation/controllers/product_form_controllers.dart

import 'package:flutter/material.dart';

class ProductFormControllers {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController skuController;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> skuValue = ValueNotifier<String?>(null);

  void init() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    skuController = TextEditingController();
  }

  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    skuController.dispose();
    isLoading.dispose();
    skuValue.dispose();
  }

  /// PERBAIKAN: Menambahkan metode untuk mengisi teks deskripsi produk
  void descriptionComponentText(String description) {
    descriptionController.text = description;
  }
}