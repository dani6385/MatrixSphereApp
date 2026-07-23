import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/models/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_sphere/screens/inventory/providers/app_provider.dart';

/// A form widget for adding or editing a product.
class AddProductForm extends StatefulWidget {
  /// The product to be edited. If null, the form is in "Add" mode.
  final Product? product;

  const AddProductForm({super.key, this.product});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _selectedImage;
  String? _initialImageUrl;

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _minStockController = TextEditingController();
  final _ageRatingController = TextEditingController();

  bool get _isEditMode => widget.product != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      final p = widget.product!;
      _nameController.text = p.name;
      _skuController.text = p.sku;
      _descriptionController.text = p.description;
      _stockController.text = p.stock.toString();
      _purchasePriceController.text = p.purchasePrice.toStringAsFixed(0);
      _sellingPriceController.text = p.sellingPrice.toStringAsFixed(0);
      _categoryController.text = p.category;
      _minStockController.text = p.minStockThreshold.toString();
      _ageRatingController.text = p.ageRating.toString();
      _initialImageUrl = p.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _categoryController.dispose();
    _minStockController.dispose();
    _ageRatingController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // Meminta pengguna memilih gambar dari galeri
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Kompresi gambar untuk menghemat ruang & bandwidth
    );

    if (pickedFile == null) {
      return; // Pengguna membatalkan pemilihan gambar
    }

    setState(() => _selectedImage = File(pickedFile.path));
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final appProvider = Provider.of<AppProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    String imageUrl = _initialImageUrl ?? '';
    List<String> imageUrls = [];

    // 1. Unggah gambar jika ada yang dipilih
    if (_selectedImage != null) {
      try {
        imageUrl =
            await appProvider.uploadImageToImgBB(imagePath: _selectedImage!.path);
        imageUrls.add(imageUrl);
      } catch (e) {
        // Handle upload error if necessary
      }
    }

    // Parse values from controllers, with fallbacks
    final stock = int.tryParse(_stockController.text) ?? 0;
    final purchasePrice = double.tryParse(_purchasePriceController.text) ?? 0.0;
    final sellingPrice = double.tryParse(_sellingPriceController.text) ?? 0.0;
    final minStock = int.tryParse(_minStockController.text) ?? 0;
    final ageRating = int.tryParse(_ageRatingController.text) ?? 0;

    // 2. Buat atau perbarui objek Product
    final productData = Product(
      // Gunakan ID yang ada jika dalam mode edit, jika tidak, biarkan kosong
      id: _isEditMode ? widget.product!.id : '',
      name: _nameController.text,
      sku: _skuController.text,
      description: _descriptionController.text,
      stock: stock,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      price: sellingPrice, // Use selling price as the main price
      category: _categoryController.text,
      minStockThreshold: minStock,
      ageRating: ageRating,
      imageUrl: imageUrl, // Gunakan URL dari hasil upload
      imageUrls: imageUrls, // Gunakan URL dari hasil upload
    );

    try {
      // 3. Panggil metode yang sesuai berdasarkan mode
      if (_isEditMode) {
        await appProvider.updateProduct(productData);
      } else {
        await appProvider.addProduct(productData);
      }

      if (mounted) {
        Navigator.of(context).pop(); // Close the form on success
        final successMessage = _isEditMode ? 'Produk "${productData.name}" berhasil diperbarui!' : 'Produk "${productData.name}" berhasil ditambahkan!';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(successMessage)));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan produk: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isEditMode ? 'Edit Produk' : 'Tambah Produk Baru',
                style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3)),
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : (_initialImageUrl != null && _initialImageUrl!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(_initialImageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImage == null && (_initialImageUrl == null || _initialImageUrl!.isEmpty)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined, color: Theme.of(context).colorScheme.primary),
                              const SizedBox(height: 4),
                              Text('Pilih Gambar', style: Theme.of(context).textTheme.bodySmall),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (value) => (value == null || value.isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _skuController,
                decoration: const InputDecoration(labelText: 'SKU'),
                validator: (value) => (value == null || value.isEmpty) ? 'SKU tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _sellingPriceController,
                decoration: const InputDecoration(labelText: 'Harga Jual'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => (value == null || value.isEmpty) ? 'Harga Jual tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => (value == null || value.isEmpty) ? 'Stok tidak boleh kosong' : null,
              ),
              // Add other fields as needed...
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _saveForm,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(_isEditMode ? 'Simpan Perubahan' : 'Simpan Produk'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}