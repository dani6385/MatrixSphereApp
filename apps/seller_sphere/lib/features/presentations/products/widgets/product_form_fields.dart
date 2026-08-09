// lib/features/products/presentation/widgets/product_form_fields.dart

import 'package:flutter/material.dart';

class ProductFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController skuController;
  final VoidCallback onScanPressed;

  const ProductFormFields({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.skuController,
    required this.onScanPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nama Produk'),
            validator: (value) =>
                value!.isEmpty ? 'Nama produk tidak boleh kosong' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: skuController,
            decoration: InputDecoration(
              labelText: 'SKU / Barcode',
              hintText: 'Scan atau masukkan kode manual',
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: onScanPressed,
                tooltip: 'Pindai Barcode',
              ),
            ),
            // Validator untuk SKU bisa opsional
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Deskripsi'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: priceController,
            decoration:
                const InputDecoration(labelText: 'Harga', prefixText: 'Rp '),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Harga tidak boleh kosong';
              if (double.tryParse(value) == null) return 'Format harga tidak valid';
              return null;
            },
          ),
        ],
      ),
    );
  }
}