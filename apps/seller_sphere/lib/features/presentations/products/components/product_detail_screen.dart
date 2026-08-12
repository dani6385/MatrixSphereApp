<<<<<<< HEAD
<<<<<<< HEAD
// d:\MatrixSphereApp\apps\seller_sphere\lib\features\presentations\products\product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:seller_sphere/features/presentations/products/models/product_model.dart';
import 'package:shared_ui/shared_ui.dart';
import '../controllers/product_detail_logic.dart'; // Impor file logika baru
=======
<<<<<<<< HEAD:apps/seller_sphere/lib/features/presentations/products/product_detail_screen.dart
// d:\MatrixSphereApp\apps\seller_sphere\lib\features\presentations\products\product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import 'controllers/product_detail_logic.dart'; // Impor file logika baru
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======

// d:\MatrixSphereApp\apps\seller_sphere\lib\features\presentations\products\product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../controllers/product_detail_logic.dart'; // Impor file logika baru



>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055

/// Layar untuk menampilkan detail lengkap dari sebuah produk.
class ProductDetailScreen extends StatefulWidget {
  final String productId;

<<<<<<< HEAD
<<<<<<< HEAD
  const ProductDetailScreen(
      {super.key,
      required this.productId,
      required String shopId,
      this.onManageStockTap});
  final void Function(Product product)? onManageStockTap;
=======
  const ProductDetailScreen({super.key, required this.productId, required String shopId});
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======
  const ProductDetailScreen({super.key, required this.productId, required String shopId});
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailLogic _logic;
<<<<<<< HEAD

=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
  @override
  void initState() {
    super.initState();
    _logic = ProductDetailLogic();
    _logic.loadProductDetails(widget.productId, (fn) => setState(fn));
  }
<<<<<<< HEAD

=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
  @override
  Widget build(BuildContext context) {
    if (_logic.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Produk')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
<<<<<<< HEAD

=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
    if (_logic.errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Produk')),
        body: Center(child: Text(_logic.errorMessage!)),
      );
    }
<<<<<<< HEAD

=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
    if (_logic.product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Produk')),
        body: const Center(child: Text('Produk tidak ditemukan.')),
      );
    }
<<<<<<< HEAD

    final product = _logic.product!;

=======
    final product = _logic.product!;
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
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
<<<<<<< HEAD
<<<<<<< HEAD
              () => _logic.loadProductDetails(
                  widget.productId, (fn) => setState(fn)),
=======
              () => _logic.loadProductDetails(widget.productId, (fn) => setState(fn)),
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======
              () => _logic.loadProductDetails(
                  widget.productId, (fn) => setState(fn)),
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
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
<<<<<<< HEAD
<<<<<<< HEAD
                    child: const Icon(Icons.broken_image,
                        size: 50, color: Colors.grey),
=======
                    child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======
                    child: const Icon(Icons.broken_image,
                        size: 50, color: Colors.grey),
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
<<<<<<< HEAD
<<<<<<< HEAD
                child: const Icon(Icons.image_not_supported,
                    size: 50, color: Colors.grey),
              ),
            const SizedBox(height: 16),
            Text(product.name,
                style: AppStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              // Display sellingPrice to the customer
              'Rp ${product.sellingPrice.toStringAsFixed(2)}',
              style: AppStyles.bodyMedium.copyWith(
                    color: kBrandPrimary,
=======
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
                child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
              ),
            const SizedBox(height: 16),
            Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text( // Display sellingPrice to the customer
              'Rp ${product.sellingPrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
<<<<<<< HEAD
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
<<<<<<< HEAD
<<<<<<< HEAD
=======

>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
            Text('SKU: ${product.sku ?? 'N/A'}',
                style: AppStyles.bodyMedium),
            const SizedBox(height: 8),
            Text('Stok: ${product.stock}',
                style: AppStyles.bodyMedium),
            const SizedBox(height: 16),
            Text(product.description,
                style: AppStyles.bodyMedium),
<<<<<<< HEAD
=======
            Text('SKU: ${product.sku ?? 'N/A'}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Stok: ${product.stock}', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======

>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
          ],
        ),
      ),
    );
  }
<<<<<<< HEAD
}
<<<<<<< HEAD
=======
========
// d:\MatrixSphereApp\apps\seller_sphere\lib\features\presentations\products\product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:seller_sphere/features/presentations/products/models/product_model.dart';
import 'package:shared_ui/shared_ui.dart';
import '../controllers/product_detail_logic.dart'; // Impor file logika baru

/// Layar untuk menampilkan detail lengkap dari sebuah produk.
class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen(
      {super.key,
      required this.productId,
      required String shopId,
      this.onManageStockTap});
  final void Function(Product product)? onManageStockTap;

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
              () => _logic.loadProductDetails(
                  widget.productId, (fn) => setState(fn)),
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
                    child: const Icon(Icons.broken_image,
                        size: 50, color: Colors.grey),
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported,
                    size: 50, color: Colors.grey),
              ),
            const SizedBox(height: 16),
            Text(product.name,
                style: AppStyles.headlineSmall),
            const SizedBox(height: 8),
            Text(
              // Display sellingPrice to the customer
              'Rp ${product.sellingPrice.toStringAsFixed(2)}',
              style: AppStyles.bodyMedium.copyWith(
                    color: kBrandPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text('SKU: ${product.sku ?? 'N/A'}',
                style: AppStyles.bodyMedium),
            const SizedBox(height: 8),
            Text('Stok: ${product.stock}',
                style: AppStyles.bodyMedium),
            const SizedBox(height: 16),
            Text(product.description,
                style: AppStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
>>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25:apps/seller_sphere/lib/features/presentations/products/components/product_detail_screen.dart
>>>>>>> 2481f3e3b66f2ed5a49d12240c79aeb34d18ce25
=======
}
>>>>>>> fdcc94e8472ffa7558367a3b266ed48cb788d055
