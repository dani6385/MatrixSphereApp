import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'add_product_screen.dart';
import 'package:shared_services/shared_services.dart';
import 'widgets/product_detail_body.dart';

/// A screen that displays detailed information about a single product.
class ProductDetailScreen extends StatefulWidget {
  final String productId;
  final String shopId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.shopId,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductService _productService = ProductService();
  late Stream<Product?> _productStream;

  @override
  void initState() {
    super.initState();
    _productStream = _productService
        .getProductsStream()
        .map((products) => products.firstWhereOrNull((product) => product.id == widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Produk',
            onPressed: () {
              AddProductScreen;
            },
          ),
        ],
      ),
      body: ProductDetailBody(productStream: _productStream),
    );
  }
}