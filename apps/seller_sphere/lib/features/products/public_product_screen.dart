// lib/screens/products/public_product_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';
import 'components/public_product_appbar.dart';
import 'components/public_product_body.dart';

class PublicProductScreen extends StatefulWidget {
  const PublicProductScreen({super.key});

  @override
  State<PublicProductScreen> createState() => _PublicProductScreenState();
}

class _PublicProductScreenState extends State<PublicProductScreen> {
  final FirebaseRtdbService _rtdbService = FirebaseRtdbService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchAllProducts();
  }

  Future<List<Product>> _fetchAllProducts() async {
    final snapshot = await _rtdbService.readData('products');
    if (snapshot != null && snapshot.exists && snapshot.value is Map) {
      final productsData = Map<String, dynamic>.from(snapshot.value as Map);
      final List<Product> productList = [];
      productsData.forEach((productId, productData) {
        if (productData is Map) {
          productList.add(Product.fromMap(
              Map<String, dynamic>.from(productData), productId));
        }
      });
      return productList;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: const PublicProductAppBar(),
      body: PublicProductBody(productsFuture: _productsFuture),
    );
  }
}