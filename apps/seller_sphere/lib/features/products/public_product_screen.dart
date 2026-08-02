// lib/screens/products/public_product_screen.dart

import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'package:shared_services/shared_services.dart';
import 'widgets/public_product_list.dart';

/// Layar untuk menampilkan ringkasan stok produk di gudang.
/// Mengambil data secara real-time dari Firebase menggunakan ProductService.
class PublicProductScreen extends StatefulWidget {
  const PublicProductScreen({super.key});

  @override
  State<PublicProductScreen> createState() => _PublicProductScreenState();
}

class _PublicProductScreenState extends State<PublicProductScreen> {
  // Instance dari ProductService untuk berinteraksi dengan database.
  final ProductService _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Produk'),
      ),
      body: PublicProductList(
        productsStream: _productService.getProductsStream(),
      ),
      // Tombol untuk menambah produk baru
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah produk (menggunakan rute addProduct)
          // Gunakan pushNamed agar lebih deklaratif dan aman
          AddProductScreen;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}