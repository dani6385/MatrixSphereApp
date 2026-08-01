import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

/// A screen for adding a new product or editing an existing one.
class AddProductScreen extends StatefulWidget {
  /// The ID of the product to edit. If null, the screen is in "add" mode.
  final String? productId;

  const AddProductScreen({super.key, this.productId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productService = ProductService();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;

  bool _isLoading = false;
  bool get _isEditMode => widget.productId != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController();

    if (_isEditMode) {
      _loadProductData();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _loadProductData() async {
    setState(() => _isLoading = true);
    try {
      // Mengambil data produk dari stream untuk mode edit
      final product = await _productService
          .getProductsStream()
          .expand((products) => products)
          .firstWhere((product) => product.id == widget.productId);

      _nameController.text = product.name;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toStringAsFixed(0);
      _stockController.text = product.stock.toString();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data produk: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return; // Jika form tidak valid, jangan lanjutkan
    }

    setState(() => _isLoading = true);

    try {
      final product = Product(
        shopId: '',
        id: _isEditMode
            ? widget.productId!
            : '', // ID akan digenerate oleh Firebase jika baru
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        stock: int.tryParse(_stockController.text) ?? 0,
        sellingPrice: 0.0,
        purchasePrice: 0.0,
      );

      if (_isEditMode) {
        await _productService.updateProduct(product);
      } else {
        await _productService.addProduct(product);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk berhasil disimpan!')),
        );
        context.pop(); // Kembali ke layar sebelumnya setelah berhasil
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan produk: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Produk' : 'Tambah Produk Baru'),
      ),
      body: _isLoading && !_isEditMode
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: AppStyles.defaultScreenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: 'Nama Produk'),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Nama produk tidak boleh kosong'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Deskripsi'),
                      maxLines: 3,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Deskripsi tidak boleh kosong'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                          labelText: 'Harga', prefixText: 'Rp '),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga tidak boleh kosong';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Format harga tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _stockController,
                      decoration:
                          const InputDecoration(labelText: 'Jumlah Stok'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stok tidak boleh kosong';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Format stok tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _saveProduct,
        label: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(_isEditMode ? 'Simpan Perubahan' : 'Tambah Produk'),
        icon: _isLoading ? null : const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
