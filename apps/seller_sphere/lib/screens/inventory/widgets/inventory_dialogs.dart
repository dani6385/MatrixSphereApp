import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:seller_sphere/screens/inventory/widgets/product_form.dart';

/// Menampilkan modal bottom sheet untuk menambah atau mengedit produk.
///
/// [context]: BuildContext dari widget yang memanggil.
/// [product]: Objek Product yang akan diedit. Jika null, ini adalah mode tambah.
/// [onSaveCallback]: Callback yang dipanggil saat form disimpan, menerima Product yang sudah diupdate/baru.
void showProductFormModal({
  required BuildContext context,
  Product? product,
  required Function(Product) onSaveCallback,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: kLightBackground,
    builder: (context) => Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: ProductForm(
        product: product,
        onSave: onSaveCallback, // Meneruskan callback ke ProductForm
      ),
    ),
  );
}

/// Menampilkan dialog konfirmasi sebelum menghapus produk.
///
/// [context]: BuildContext dari widget yang memanggil.
/// [productName]: Nama produk yang akan dihapus.
/// [onDeleteConfirmed]: Callback yang dipanggil jika pengguna mengkonfirmasi penghapusan.
void showDeleteConfirmationDialog({
  required BuildContext context,
  required String productName,
  required Function(String) onDeleteConfirmed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Anda yakin ingin menghapus produk "$productName"?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: kAlertRed),
            child: const Text('Hapus'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onDeleteConfirmed(productName); // Panggil callback jika dikonfirmasi
            },
          ),
        ],
      );
    },
  );
}