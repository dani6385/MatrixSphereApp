import 'package:flutter/material.dart';
import 'package:seller_sphere/models/product.dart';
import 'package:shared_ui/shared_ui.dart';

/// A utility class for showing dialogs related to the inventory screen.
class InventoryDialogs {
  /// Shows a placeholder snackbar for the "Add Product" feature.
  static void showAddProductDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Fungsi 'Tambah Barang' belum diimplementasikan.")));
  }

  /// Shows a placeholder snackbar for the "Import/Export CSV" feature.
  static void showCsvDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Fungsi 'Impor/Ekspor CSV' belum diimplementasikan.")));
  }

  /// Shows a confirmation dialog for deleting a product.
  ///
  /// Requires [context], the [product] to be deleted, and an [onDelete]
  /// callback that is executed when the user confirms the deletion.
  static void showDeleteDialog({
    required BuildContext context,
    required Product product,
    required VoidCallback onDelete,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Produk?"),
        content: Text("Apakah Anda yakin ingin menghapus '${product.name}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Batal")),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete();
            },
            style: FilledButton.styleFrom(backgroundColor: kRadiantRose),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }
}