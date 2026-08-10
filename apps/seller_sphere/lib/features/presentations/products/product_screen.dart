// lib/screens/products/public_product_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

import 'widgets/product_list.dart';

/// Layar untuk menampilkan ringkasan stok produk di gudang.
/// Mengambil data secara real-time dari Firebase menggunakan ProductService.
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // Instance dari ProductService untuk berinteraksi dengan database.
  final ProductService _productService = ProductService();

  // Method untuk menghapus produk dengan dialog konfirmasi
  Future<void> _deleteProduct(Product product) async {
    // Tampilkan dialog konfirmasi sebelum menghapus
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
              'Apakah Anda yakin ingin menghapus produk "${product.name}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Hapus',
                  style: AppStyles.bodyMedium
                      .copyWith(color: context.colorScheme.error)),
            ),
          ],
        );
      },
    );

    // Jika pengguna menekan "Hapus" pada dialog
    if (confirmed == true) {
      try {
        await _productService.deleteProduct(product.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil dihapus.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus produk: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
      ),
      body: ProductList(
        productsStream: _productService.getProductsStream(),
        onProductTap: (product) {
          // Navigasi ke halaman detail produk (contoh)
          // Anda bisa menyesuaikan rute dan parameter sesuai kebutuhan
          context.push('/product-detail/${product.id}');
        },
        onEditTap: (product) {
          // Navigasi ke halaman edit produk
          context.push('/edit-product/${product.id}');
        },
        onDeleteTap: (product) {
          _deleteProduct(product);
        },
        onManageStockTap: (product) {
          context.push('/inventory-detail/${product.id}');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-product'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
