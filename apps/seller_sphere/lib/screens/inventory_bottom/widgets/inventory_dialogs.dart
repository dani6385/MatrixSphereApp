import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:seller_sphere/screens/inventory_bottom/widgets/add_product_form.dart';
import 'package:shared_ui/shared_ui.dart';

/// A utility class for showing dialogs related to the inventory screen.
class InventoryDialogs {
  /// Shows a modal bottom sheet with a form to add or edit a product.
  ///
  /// If [product] is provided, the form will be in "Edit" mode.
  /// Otherwise, it will be in "Add" mode.
  static void showProductFormDialog(BuildContext context, {Product? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Important for keyboard to not cover the form
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AddProductForm(product: product),
    );
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

  static void showAddProductDialog(BuildContext context) {}
}