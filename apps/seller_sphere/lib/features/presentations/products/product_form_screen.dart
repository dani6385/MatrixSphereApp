// lib/features/products/presentation/add_edit_product_screen.dart

import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
import 'package:shared_ui/shared_ui.dart';
import 'controllers/add_product_logic.dart'; // Menggunakan logika terpusat
import 'widgets/product_form_fields.dart';
import 'widgets/product_image_picker.dart';
import 'widgets/product_form_actions.dart';
import 'widgets/image_picker_bottom_sheet.dart';

/// Halaman gabungan untuk menambah produk baru atau mengedit produk yang sudah ada.
class ProductFormScreen extends StatefulWidget {
  final String? productId; // Jika null = Tambah Baru, Jika ada isi = Edit Mode

  const ProductFormScreen({super.key, this.productId});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  late final AddProductLogic _logic;
  bool get _isEditMode => widget.productId != null;

  @override
  void initState() {
    super.initState();
    _logic = AddProductLogic();
    _logic.initControllers();

    // Jika dalam mode edit, muat data produk berdasarkan ID
    if (_isEditMode) {
      _logic.loadProductData(widget.productId!).then((_) {
        // Logika pengaman jika produk ternyata tidak ditemukan di database
        if (mounted) {
          setState(() {
            // setState ini memberi tahu UI untuk menggambar ulang
            // setelah controller terisi data dari database/logic
          });
        }
      });
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
                  // Komponen Pemilih Gambar (hanya tampil atau relevan diintegrasikan)
                  ProductImagePicker(
                    selectedImageFile: _logic.selectedImageFile,
                    existingImageUrl: _logic.existingImageUrl,
                    onPickImage: () {
                      ImagePickerBottomSheet.show(context, (source) {
                        _logic.pickImage(source);
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  // Form Fields untuk mengisi Nama, Deskripsi, Harga, dan SKU
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
      // Tombol Aksi Simpan di bagian bawah layar
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _logic.isLoading,
        builder: (context, isLoading, child) {
          return ProductFormActions(
            isLoading: isLoading,
            isEditMode: _isEditMode,
            onSavePressed: () => _logic.saveProduct(
              context: context,
              isEditMode: _isEditMode,
              productId: widget.productId,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}