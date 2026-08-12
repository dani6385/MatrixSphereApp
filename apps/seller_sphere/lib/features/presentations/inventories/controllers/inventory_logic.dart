import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart'; // For Product and ProductService
import 'package:logger/logger.dart';

final Logger _logger = Logger();


class InventoryLogic {
  final ProductService _productService = ProductService();

  /// Memperbarui stok produk secara langsung.
  Future<void> updateProductStockDirectly(BuildContext context, Product product, int newStock) async {
    try {
      // Buat objek produk baru dengan stok yang diperbarui
      final updatedProduct = product.copyWith(stock: newStock);
      await _productService.updateProduct(updatedProduct);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stok ${product.name} berhasil diperbarui menjadi $newStock!')),
        );
      }
    } catch (e) {
      _logger.e('Error updating stock for ${product.name}: $e'); // Use .e for error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui stok ${product.name}: $e')),
        );
      }
    }
  }
}
  