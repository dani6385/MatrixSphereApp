// lib/features/presentations/products/widgets/product_dialog_helper.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

class ProductDialogHelper {
  /// Menampilkan dialog untuk memperbarui stok produk[cite: 8].
  /// Mengembalikan nilai `true` jika pembaruan berhasil, atau `false` jika dibatalkan[cite: 8].
  static Future<bool> showStockUpdateDialog(
    BuildContext context,
    Product product,
    Future<void> Function(Product updatedProduct) onUpdateProduct,
  ) async {
    final stockController = TextEditingController(text: product.stock.toString());
    final formKey = GlobalKey<FormState>();

    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Stok: ${product.name}'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: stockController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Stok Baru'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Stok tidak boleh kosong';
                }
                if (int.tryParse(value) == null) {
                  return 'Masukkan angka yang valid';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newStock = int.parse(stockController.text);
                  try {
                    // Membuat salinan produk dengan stok baru
                    final updatedProduct = product.copyWith(stock: newStock);
                    await onUpdateProduct(updatedProduct);
                    
                    if (context.mounted) {
                      Navigator.of(context).pop(true); // Berhasil
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal update stok: $e')),
                      );
                    }
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}