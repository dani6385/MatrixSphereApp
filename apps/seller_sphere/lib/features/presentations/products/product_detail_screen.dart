// d:\MatrixSphereApp\apps\seller_sphere\lib\features\presentations\products\product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'controllers/product_detail_logic.dart'; // Impor file logika baru

/// Layar untuk menampilkan detail lengkap dari sebuah produk.
class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId, required String shopId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = ProductDetailLogic();
    _logic.loadProductDetails(widget.productId, (fn) => setState(fn));
  }

  @override
  Widget build(BuildContext context) {
    if (_logic.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Produk')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_logic.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Produk')),
        body: Center(child: Text(_logic.errorMessage!)),
      );
    }

    if (_logic.product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Produk')),
        body: const Center(child: Text('Produk tidak ditemukan.')),
      );
    }

    final product = _logic.product!;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Tombol Hapus Produk
          FloatingActionButton(
            heroTag: 'btnDelete',
            backgroundColor: kAlertRed,
            foregroundColor: kBrandWhite,
            onPressed: () => _logic.deleteProduct(context, product.id),
            child: const Icon(Icons.delete),
          ),
          const SizedBox(width: 16),
          // Tombol Edit Produk yang sudah ada
          FloatingActionButton(
            heroTag: 'btnEdit',
            onPressed: () => _logic.onEditPressed(
              context,
              product.id,
              () => _logic.loadProductDetails(widget.productId, (fn) => setState(fn)),
            ),
            child: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  product.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
              ),
            const SizedBox(height: 16),
            Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text( // Display sellingPrice to the customer
              'Rp ${product.sellingPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text('SKU: ${product.sku ?? 'N/A'}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Stok: ${product.stock}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}