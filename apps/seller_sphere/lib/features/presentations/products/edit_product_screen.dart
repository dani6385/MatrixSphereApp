// lib/features/products/presentation/edit_product_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'controllers/edit_product_logic.dart'; // Impor file logika baru

/// Halaman form untuk mengedit detail produk yang sudah ada.
class EditProductScreen extends StatefulWidget {
  final String productId;

  const EditProductScreen({super.key, required this.productId});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late final EditProductLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = EditProductLogic();
    _logic.initControllers();
    
    // Memuat data produk saat pertama kali dibuka
    _logic.loadProduct(widget.productId, (fn) => setState(fn)).then((_) {
      // Tangani jika produk tidak ditemukan setelah dimuat
      if (_logic.product == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk tidak ditemukan.')),
        );
        context.pop();
      }
    });
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
        title: const Text('Edit Produk'),
        actions: [
          if (_logic.isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: CircularProgressIndicator(color: Colors.white)),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => _logic.saveProduct(context, (fn) => setState(fn)),
            ),
        ],
      ),
      body: _logic.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _logic.formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  TextFormField(
                    controller: _logic.nameController,
                    decoration: const InputDecoration(labelText: 'Nama Produk'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _logic.descriptionController,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                    maxLines: 3,
                  ),
                  TextFormField(
                    controller: _logic.priceController,
                    decoration: const InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _logic.stockController,
                    decoration: const InputDecoration(labelText: 'Stok'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  TextFormField(
                    controller: _logic.skuController,
                    decoration: const InputDecoration(labelText: 'SKU (Opsional)'),
                  ),
                ],
              ),
            ),
    );
  }
}