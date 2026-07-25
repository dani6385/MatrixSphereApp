import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/services/product_service.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? initialProduct;

  const ProductFormScreen({super.key, this.initialProduct});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _skuController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;

  bool get _isEditing => widget.initialProduct != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProduct?.name);
    _skuController = TextEditingController(text: widget.initialProduct?.sku);
    _priceController =
        TextEditingController(text: widget.initialProduct?.price.toString());
    _stockController =
        TextEditingController(text: widget.initialProduct?.stock.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.initialProduct?.id ?? '',
        name: _nameController.text,
        sku: _skuController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        stock: int.tryParse(_stockController.text) ?? 0,
        imageUrl: widget.initialProduct?.imageUrl,
        purchasePrice: 0,
        sellingPrice: 0,
        minStockThreshold: 0,
        ageRating: 0,
        imageUrls: [], // Keep existing image
      );

      final productService = ProductService();
      try {
        if (_isEditing) {
          await productService.updateProduct(product);
        } else {
          await productService.addProduct(product);
        }
        if (mounted) {
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menyimpan produk: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Produk' : 'Tambah Produk'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _skuController,
                decoration: const InputDecoration(labelText: 'SKU'),
                validator: (value) =>
                    value!.isEmpty ? 'SKU tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) =>
                    value!.isEmpty ? 'Harga tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) =>
                    value!.isEmpty ? 'Stok tidak boleh kosong' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kNeonCyan,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
