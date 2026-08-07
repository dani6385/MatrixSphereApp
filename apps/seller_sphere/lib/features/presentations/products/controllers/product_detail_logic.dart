import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
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
  void onEditPressed(BuildContext context, String productId, VoidCallback onProductUpdated) {
    context.push(
      '${AppRoutes.productDetail}/edit', // Asumsi path edit adalah /products/{id}/edit
      extra: productId, // Kirim productId sebagai 'extra'
    ).then((_) {
      // Panggil callback untuk memuat ulang detail produk setelah halaman edit ditutup
      onProductUpdated();
    });
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