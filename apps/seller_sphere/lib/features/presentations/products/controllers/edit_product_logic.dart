// lib/features/products/presentation/controllers/edit_product_logic.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_services/shared_services.dart';

class EditProductLogic {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ProductService productService = ProductService();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController sellingPriceController; // Renamed for clarity
  late TextEditingController stockController;
  late TextEditingController skuController;

  bool isLoading = true;
  bool isSaving = false;
  Product? product;

  void initControllers() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    sellingPriceController = TextEditingController(); // Initialized
    stockController = TextEditingController();
    skuController = TextEditingController();
  }

  void disposeControllers() {
    nameController.dispose();
    descriptionController.dispose();
    sellingPriceController.dispose(); // Disposed
    stockController.dispose();
    skuController.dispose();
  }

  /// Memuat data produk berdasarkan ID
  Future<void> loadProduct(String productId, StateSetter setStateParent) async {
    final fetchedProduct = await productService.getProductById(productId);
    if (fetchedProduct != null) {
      setStateParent(() {
        product = fetchedProduct;
        nameController.text = fetchedProduct.name;
        descriptionController.text = fetchedProduct.description;
        sellingPriceController.text = fetchedProduct.sellingPrice.toString(); // Load sellingPrice
        stockController.text = fetchedProduct.stock.toString();
        skuController.text = fetchedProduct.sku ?? '';
        isLoading = false;
      });
    } else {
      setStateParent(() => isLoading = false);
    }
  }

  /// Menyimpan perubahan data produk
  Future<void> saveProduct(BuildContext context, StateSetter setStateParent) async {
    if (formKey.currentState!.validate() && product != null) {
      setStateParent(() => isSaving = true);

      final updatedProduct = product!.copyWith(
        name: nameController.text,
        description: descriptionController.text,
        sellingPrice: double.tryParse(sellingPriceController.text) ?? product!.sellingPrice, // Save to sellingPrice
        stock: int.tryParse(stockController.text) ?? product!.stock,
        sku: skuController.text,
      );

      try {
        await productService.updateProduct(updatedProduct);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil diperbarui!')),
          );
          context.pop(true);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan produk: $e')),
          );
        }
      } finally {
        setStateParent(() => isSaving = false);
      }
    }
  }
}