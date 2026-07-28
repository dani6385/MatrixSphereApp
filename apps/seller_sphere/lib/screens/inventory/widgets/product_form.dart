import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:image_picker/image_picker.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;

  const ProductForm({
    super.key,
    this.product,
    required this.onSave,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _descriptionController;
  late bool _isEditing;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;

    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _categoryController =
        TextEditingController(text: widget.product?.category ?? '');
    _priceController = TextEditingController(
        text: _isEditing ? widget.product!.price.toStringAsFixed(0) : '');
    _stockController = TextEditingController(
        text: _isEditing ? widget.product!.stock.toString() : '');
    _descriptionController =
        TextEditingController(text: widget.product?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Menampilkan pilihan untuk mengambil gambar dari Kamera atau Galeri
  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri Foto'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _handleSave() async {
    if (_formKey.currentState!.validate()) {
      // Menampilkan loading indicator saat mengunggah
      // (Implementasi loading indicator yang lebih baik bisa ditambahkan)
      String? finalImageUrl = widget.product?.imageUrl ?? '';

      if (_selectedImage != null) {
        final uploadedUrl =
            await ImageUploadService().uploadImageToImgBB(_selectedImage!);

        if (uploadedUrl == null) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengunggah gambar.')),
          );
          return;
        }
        finalImageUrl = uploadedUrl;
      }

      final productData = Product(
        id: widget.product?.id ?? '',
        name: _nameController.text,
        category: _categoryController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        stock: int.tryParse(_stockController.text) ?? 0,
        description: _descriptionController.text,
        imageUrl: finalImageUrl,
        // Gunakan nilai yang ada atau default jika produk baru
        purchasePrice: widget.product?.purchasePrice ?? 0,
        sellingPrice: widget.product?.sellingPrice ?? 0,
        minStockThreshold: widget.product?.minStockThreshold ?? 0,
        ageRating: widget.product?.ageRating ?? 0,
        imageUrls: widget.product?.imageUrls ?? [],
      );
      widget.onSave(productData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_isEditing ? 'Edit Produk' : 'Tambah Produk Baru',
                style: AppStyles.primaryTitle(Theme.of(context).textTheme)),
            const SizedBox(height: AppSpacing.lg),
            // Image Preview and Picker
            GestureDetector(
              onTap: _showImageSourceActionSheet,
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: kLightBackground,
                  border: Border.all(color: kLightBorder),
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppSpacing.sm),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      )
                    : (widget.product!.imageUrl?.isNotEmpty == true)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(AppSpacing.sm), 
                            child: Image.network(widget.product!.imageUrl!,
                                fit: BoxFit.cover),
                          )
                        : const Center(
                            child: Icon(Icons.add_a_photo_outlined,
                                size: 40, color: kLightTextSecondary),
                          ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
                controller: _nameController,
                readOnly: _isEditing,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                keyboardType: TextInputType.text,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Kategori'),
                keyboardType: TextInputType.text),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi')),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: kLightBackground,
                foregroundColor: kLightTextPrimary,
              ),
              onPressed: _handleSave,
              child: const Text('Simpan Produk'),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
