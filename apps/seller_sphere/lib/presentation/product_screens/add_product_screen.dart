import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/presentation/product_screens/providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  final String? productId; // Make productId optional

  const AddProductScreen({super.key, this.productId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _productImage;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  Product? _existingProduct;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (widget.productId != null) {
        // Edit mode
        _existingProduct = Provider.of<ProductProvider>(context, listen: false)
            .findById(widget.productId!);
        _nameController.text = _existingProduct!.name;
        _priceController.text = _existingProduct!.price.toStringAsFixed(0);
        _descriptionController.text = _existingProduct!.description;
        // Set initial image from existing product
        if (_existingProduct!.imagePath.isNotEmpty) {
          _productImage = File(_existingProduct!.imagePath);
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _productImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    // In edit mode, image is not mandatory to change
    if (!isValid || (_productImage == null && _existingProduct == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pastikan semua data terisi dan gambar produk telah dipilih.'),
          backgroundColor: AppColors.secondary,
        ),
      );
      return;
    }

    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    if (_existingProduct != null) {
      // Update existing product
      productProvider.updateProduct(
        id: _existingProduct!.id,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        newImageFile: _productImage,
      );
    } else {
      // Add new product
      productProvider.addProduct(
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        imageFile: _productImage!,
      );
    }

    // Tampilkan pesan sukses dan kembali ke layar sebelumnya
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _existingProduct != null
              ? 'Produk berhasil diperbarui!'
              : 'Produk berhasil ditambahkan!',
        ),
      ),
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = _existingProduct != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditMode ? 'Edit Produk' : 'Tambah Produk Baru',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Image Picker
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: _productImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_productImage!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Pilih Gambar Produk'),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Form Fields
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
              validator: (value) => (value == null || value.isEmpty) ? 'Nama produk tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Harga', prefixText: 'Rp '),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) => (value == null || value.isEmpty) ? 'Harga tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi Produk'),
              maxLines: 4,
              validator: (value) => (value == null || value.isEmpty) ? 'Deskripsi tidak boleh kosong' : null,
            ),
            const SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(isEditMode ? 'Simpan Perubahan' : 'Simpan Produk'),
            ),
          ],
        ),
      ),
    );
  }
}