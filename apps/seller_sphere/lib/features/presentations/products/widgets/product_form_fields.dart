// lib/screens/products/widgets/product_form_fields.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController stockController;

  const ProductFormFields({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.stockController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nama Produk'),
            validator: (value) => (value == null || value.isEmpty)
                ? 'Nama produk tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Deskripsi'),
            maxLines: 3,
            validator: (value) => (value == null || value.isEmpty)
                ? 'Deskripsi tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: priceController,
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
            controller: stockController,
            decoration: const InputDecoration(labelText: 'Jumlah Stok'),
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
    );
  }
}