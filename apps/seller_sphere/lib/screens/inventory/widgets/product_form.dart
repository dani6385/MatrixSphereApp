import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

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
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _descriptionController;
  late bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;

    _nameController = TextEditingController(text: widget.product?.name ?? '');
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
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final productData = Product(
        id: widget.product?.id ?? '',
        name: _nameController.text,
        price: double.tryParse(_priceController.text) ?? 0,
        stock: int.tryParse(_stockController.text) ?? 0,
        description: _descriptionController.text,
        imageUrl: widget.product?.imageUrl ?? '',
        purchasePrice: 0.0,
        sellingPrice: 0.0,
        minStockThreshold: 0,
        ageRating: 0,
        imageUrls: const [],
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
            TextFormField(
                controller: _nameController,
                readOnly: _isEditing,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
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
