import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_sphere/presentation/product_screens/models/product_model.dart';
import 'package:seller_sphere/presentation/product_screens/providers/product_provider.dart';
import 'package:seller_sphere/utils/ui_helpers.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  final String? productId;

  const AddProductScreen({super.key, this.productId});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final List<File> _imageFiles = [];
  List<String> _imageUrls = [];
  DateTime? _createdAt;

  bool get _isEditMode => widget.productId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _setupControllers(Product product) {
    _nameController.text = product.name;
    _priceController.text = product.price.toStringAsFixed(0);
    _stockController.text = product.stock.toString();
    _imageUrls = List<String>.from(product.imageUrls);
    _createdAt = product.createdAt;
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Set state ke loading
    ref.read(productMutationProvider.notifier).state = true;

    try {
      final repository = ref.read(productRepositoryProvider);
      final newProduct = Product(
        id: widget.productId ?? '',
        name: _nameController.text,
        price: double.parse(_priceController.text),
        stock: int.parse(_stockController.text),
        imageUrls: _imageUrls,
        // Gunakan _createdAt jika ada (mode edit), atau waktu sekarang (mode tambah)
        createdAt: _createdAt ?? DateTime.now(),
      );

      if (_isEditMode) {
        await repository.updateProduct(newProduct, imagePaths: _imageFiles.map((f) => f.path).toList());
      } else {
        await repository.addProduct(newProduct, imagePaths: _imageFiles.map((f) => f.path).toList());
      }

      // Invalidate provider daftar produk agar data dimuat ulang di halaman sebelumnya
      ref.invalidate(productListProvider);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil ${_isEditMode ? 'diperbarui' : 'disimpan'}!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan produk: $e')));
    } finally {
      ref.read(productMutationProvider.notifier).state = false;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      // Menggunakan pickMultipleImage untuk galeri
      if (source == ImageSource.gallery) {
        final pickedFiles = await picker.pickMultiImage(imageQuality: 80, maxWidth: 1024);
        setState(() {
          _imageFiles.addAll(pickedFiles.map((file) => File(file.path)));
        });
      } else { // Logika untuk kamera tetap sama (satu gambar)
        final pickedFile = await picker.pickImage(source: source, imageQuality: 80, maxWidth: 1024);
        if (pickedFile != null) setState(() => _imageFiles.add(File(pickedFile.path)));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil gambar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Jika dalam mode edit, kita perlu memuat data produk terlebih dahulu.
    if (_isEditMode) {
      final productAsync = ref.watch(productDetailProvider(widget.productId!));
      return productAsync.when(
        loading: () => Scaffold(
          appBar: AppBar(title: const Text('Memuat Produk...')),
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: Center(child: Text('Gagal memuat produk: $err')),
        ),
        data: (product) {
          // Setelah data tersedia, kita isi controller dan bangun UI form.
          _setupControllers(product);
          return _buildForm();
        },
      );
    } else {
      // Jika mode tambah, langsung tampilkan form kosong.
      return _buildForm();
    }
  }

  Widget _buildForm() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Produk' : 'Tambah Produk'),
        actions: [
          // Tampilkan loading indicator atau tombol simpan
          ref.watch(productMutationProvider)
              ? const Padding(padding: EdgeInsets.all(16.0), child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white)))
              : IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveProduct,
                  tooltip: 'Simpan Produk',
                ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            SizedBox(
              height: 120,
              child: _buildImagePreviewList(),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Produk',
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.isEmpty) ? 'Nama produk tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Harga',
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) return 'Harga tidak boleh kosong';
                if (double.tryParse(value) == null) return 'Format harga tidak valid';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stockController,
              decoration: const InputDecoration(
                labelText: 'Stok',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) return 'Stok tidak boleh kosong';
                if (int.tryParse(value) == null) return 'Format stok tidak valid';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreviewList() {
    // Gabungkan gambar dari URL (mode edit) dan file lokal (baru dipilih)
    final allImages = [..._imageUrls, ..._imageFiles];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: allImages.length + 1, // +1 untuk tombol tambah
      itemBuilder: (context, index) {
        if (index == allImages.length) {
          // Tombol Tambah Gambar
          return GestureDetector(
            onTap: () => showImagePickerOptions(context, onPick: _pickImage),
            child: Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
              ),
              child: const Icon(Icons.add_a_photo_outlined, color: Colors.grey, size: 40),
            ),
          );
        }

        final image = allImages[index];
        return Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: image is String
                ? Image.network(image, fit: BoxFit.cover)
                : Image.file(image as File, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}