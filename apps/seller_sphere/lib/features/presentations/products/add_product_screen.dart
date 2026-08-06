// lib/features/products/presentation/add_product_screen.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_ui/shared_ui.dart';
import 'controllers/add_product_logic.dart'; // Impor file logika yang baru dibuat
import 'widgets/product_form_fields.dart';
import 'widgets/product_image_picker.dart';
import 'widgets/product_form_actions.dart';

/// A screen for adding a new product or editing an existing one.
class AddProductScreen extends StatefulWidget {
  final String? productId;

  const AddProductScreen({super.key, this.productId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late final AddProductLogic _logic;
  bool get _isEditMode => widget.productId != null;

  @override
  void initState() {
    super.initState();
    _logic = AddProductLogic();
    _logic.initControllers();

    if (_isEditMode) {
      _logic.loadProductData(widget.productId!, (fn) => setState(fn));
    }
  }

  @override
  void dispose() {
    _logic.disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Produk' : 'Tambah Produk Baru'),
      ),
      body: _logic.isLoading.value && !_isEditMode
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: AppStyles.defaultScreenPadding,
              child: Column(
                children: [
                  ProductImagePicker(
                    selectedImageFile: _logic.selectedImageFile,
                    existingImageUrl: _logic.existingImageUrl,
                    onPickImage: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return SafeArea(
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Galeri'),
                                  onTap: () {
                                    _logic.pickImage(ImageSource.gallery);
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('Kamera'),
                                  onTap: () {
                                    _logic.pickImage(ImageSource.camera);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  ProductFormFields(
                    formKey: _logic.formKey,
                    nameController: _logic.nameController,
                    descriptionController: _logic.descriptionController,
                    priceController: _logic.priceController,
                    skuController: _logic.skuController,
                    onScanPressed: () => _logic.scanBarcode(context),
                  ),
                ],
              ),
            ),
      floatingActionButton: ProductFormActions(
        isLoading: _logic.isLoading.value,
        isEditMode: _isEditMode,
        onSavePressed: () => _logic.saveProduct(
          context: context,
          isEditMode: _isEditMode,
          productId: widget.productId,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
