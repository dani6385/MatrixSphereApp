import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigation/app_routes.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

// Model data sederhana untuk produk (hardcoded)
class _Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int stock;

  _Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
  });
}

class ProductScreen extends StatefulWidget {
  // Parameter ini mungkin akan berguna saat Anda mengambil data dari Firebase
  final String? shopUid;

  const ProductScreen({super.key, this.shopUid, required Product product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  // Data produk hardcoded untuk contoh
  final List<_Product> _products = [
    _Product(
        id: 'prod-001',
        name: 'Kopi Robusta Premium',
        description: 'Biji kopi pilihan dari pegunungan',
        price: 75000,
        stock: 50),
    _Product(
        id: 'prod-002',
        name: 'Kaos Polos Katun',
        description: 'Bahan adem dan nyaman dipakai',
        price: 120000,
        stock: 120),
    _Product(
        id: 'prod-003',
        name: 'Lampu Meja Belajar LED',
        description: 'Terang dan hemat energi',
        price: 150000,
        stock: 30),
    _Product(
        id: 'prod-004',
        name: 'Buku Catatan Spiral A5',
        description: 'Kertas tebal dan tidak mudah sobek',
        price: 25000,
        stock: 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBrandTertiary, // Menyamakan background dengan Attendance
      appBar: AppBar(
        title: const Text('Manajemen Produk'),
        backgroundColor: kDarkSecondary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Tambah Produk Baru',
            onPressed: () {
              // Navigasi ke halaman tambah produk
              context.go(AppRoutes.productAdd);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return Card(
            color: kDarkSecondary,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(product.name, style: const TextStyle(color: kLightTextPrimary)),
              subtitle: Text(
                'Harga: Rp ${product.price.toStringAsFixed(0)} - Stok: ${product.stock}',
                style: const TextStyle(color: kLightTextSecondary),
              ),
              trailing: const Icon(Icons.chevron_right, color: kAccent),
              onTap: () {
                // Navigasi ke halaman edit produk saat item di-tap
                // Menggunakan path dari AppRoutes.productEdit
                context.go(AppRoutes.productEdit.replaceFirst(':productId', product.id));
              },
            ),
          );
        },
      ),
    );
  }
}
