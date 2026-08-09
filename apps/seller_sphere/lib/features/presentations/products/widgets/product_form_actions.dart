// lib/features/products/presentation/widgets/product_form_actions.dart

import 'package:flutter/material.dart';

class ProductFormActions extends StatelessWidget {
  final bool isLoading;
  final bool isEditMode;
  final VoidCallback onSavePressed;

  const ProductFormActions({
    super.key,
    required this.isLoading,
    required this.isEditMode,
    required this.onSavePressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: isLoading ? null : onSavePressed,
      label: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(isEditMode ? 'Simpan Perubahan' : 'Tambah Produk'),
      icon: isLoading ? null : const Icon(Icons.save),
    );
  }
}