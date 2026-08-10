import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_services/shared_services.dart';

class ProductDetailLogic {
  final ProductService _productService = ProductService();
  
  Product? product;
  bool isLoading = true;
  String? errorMessage;

  /// Memuat detail produk dari database berdasarkan productId.
  Future<void> loadProductDetails(String productId, StateSetter setStateParent) async {
    setStateParent(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final fetchedProduct = await _productService.getProductById(productId);
      setStateParent(() {
        product = fetchedProduct;
        isLoading = false;
      });
    } catch (e) {
      setStateParent(() {
        errorMessage = 'Gagal memuat detail produk: $e';
        isLoading = false;
      });
    }
  }

  /// Menangani aksi ketika tombol edit ditekan
  Future<void> onEditPressed(BuildContext context, String productId, Function() reloadCallback) async {
    // Pastikan produk tidak null sebelum menavigasi
    if (product == null) return;

    // Navigasi ke halaman edit dengan membawa objek produk yang sudah ada
    // Ini memungkinkan halaman form untuk langsung diisi tanpa perlu fetch ulang.
    final result = await context.push('/products/edit/$productId', extra: product);

    if (result == true) {
      reloadCallback();
    }
  }
  /// Menghapus produk dari database setelah konfirmasi
  Future<void> deleteProduct(BuildContext context, String productId) async {
    // Tampilkan dialog konfirmasi terlebih dahulu
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _productService.deleteProduct(productId);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil dihapus')),
          );
          // Kembali ke halaman sebelumnya dan bawa sinyal true
          context.pop(true);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus produk: $e')),
          );
        }
      }
    }
  }
}