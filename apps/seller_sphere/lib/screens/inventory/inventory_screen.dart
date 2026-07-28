import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:firebase_database/firebase_database.dart';

import 'widgets/product_form.dart';
import 'widgets/product_list_view.dart';


class InventoryScreen extends StatefulWidget {
  // Asumsikan shopUid didapat dari user yang sedang login atau dari halaman sebelumnya.
  // Untuk contoh ini, kita akan hardcode. Dalam aplikasi nyata, ini harus dinamis.
  final String shopUid;

  const InventoryScreen({super.key, required this.shopUid});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  // Gunakan service layer untuk interaksi database
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();
  late final DatabaseReference _productsRef;

  @override
  void initState() {
    super.initState();
    // Tentukan path yang benar untuk produk toko ini
    _productsRef =
        FirebaseDatabase.instance.ref('seller_sphere/${widget.shopUid}/produk');
  }

  void _showProductFormDialog({Product? product}) {
    final bool isEditing = product != null;

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
          onSave: (productData) async {
            await _rtdbService.updateData(
              _productsRef.path,
              {productData.name: productData.toMap()},
            );

            if (!context.mounted) return;

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Produk berhasil ${isEditing ? 'diperbarui' : 'ditambahkan'}!'),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris Toko'),
        backgroundColor: kLightBackground,
      ),
      body: StreamBuilder(
        stream: _productsRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('Belum ada produk.'));
          }

          // Konversi data dari Firebase ke List<Product>
          final productsMap =
              Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);
          final List<Product> products = productsMap.entries.map((entry) {
            // Key adalah nama produk, value adalah detail produk
            return Product.fromMap(
                Map<String, dynamic>.from(entry.value), entry.key);
          }).toList();

          return ProductListView(
            products: products,
            onEdit: (product) => _showProductFormDialog(product: product),
            onDelete: (productName) => _confirmDeleteProduct(productName),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showProductFormDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
        backgroundColor: kLightBackground,
      ),
    );
  }

  // Menampilkan dialog konfirmasi sebelum menghapus produk
  Future<void> _confirmDeleteProduct(String productName) async {
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
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _deleteProduct(productName);
              },
            ),
          ],
        );
      },
    );
  }

  // Logika untuk menghapus produk dari Firebase
  Future<void> _deleteProduct(String productName) async {
    try {
      final success =
          await _rtdbService.deleteData('${_productsRef.path}/$productName');

      // Periksa apakah widget masih ada sebelum menggunakan BuildContext.
      if (!mounted || !success) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil dihapus!')),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus produk: $e')),
      );
    }
  }
}
