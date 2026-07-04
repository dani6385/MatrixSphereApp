import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_sphere/presentation/product_screens/providers/product_provider.dart';
import 'package:shared_ui/shared_ui.dart';

// 1. Ubah menjadi ConsumerStatefulWidget
class AddProductScreen extends ConsumerStatefulWidget {
  final String? productId;

  const AddProductScreen({super.key, this.productId});

  @override
  // 2. Ubah return type menjadi ConsumerState
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

// 3. Ubah State menjadi ConsumerState
class _AddProductScreenState extends ConsumerState<AddProductScreen> {
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
        // Edit mode: Gunakan ref.read untuk mengakses provider
        _existingProduct = ref.read(productProvider).findById(widget.productId!);
        _nameController.text = _existingProduct!.name;
        _priceController.text = _existingProduct!.price.toStringAsFixed(0);
        _descriptionController.text = _existingProduct!.description;
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
    if (!isValid || (_productImage == null && _existingProduct == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pastikan semua data terisi dan gambar produk telah dipilih.'),
          backgroundColor: AppColors.secondary,
        ),
      );
      return;
    }

    // 4. Gunakan ref.read untuk memanggil metode pada notifier
    final productNotifier = ref.read(productProvider.notifier);

    if (_existingProduct != null) {
      productNotifier.updateProduct(
        id: _existingProduct!.id,
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        newImageFile: _productImage,
      );
    } else {
      productNotifier.addProduct(
        name: _nameController.text,
        price: double.parse(_priceController.text),
        description: _descriptionController.text,
        imageFile: _productImage!,
      );
    }

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
        title: Text(isEditMode ? 'Edit Produk' : 'Tambah Produk Baru'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
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

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Nama produk tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Harga', prefixText: 'Rp '),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Harga tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi Produk'),
              maxLines: 4,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Deskripsi tidak boleh kosong' : null,
            ),
            const SizedBox(height: 32),

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
