import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/presentation/product_screens/providers/product_provider.dart';
import 'package:shared_ui/shared_ui.dart';

class ProductListScreen extends ConsumerWidget { // 1. Ubah menjadi ConsumerWidget
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // 2. Tambahkan WidgetRef
    // 3. Gunakan ref.watch untuk mendapatkan state dari provider
    final productState = ref.watch(productProvider);
    final products = productState.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Tambah Produk',
            onPressed: () {
              context.push('/add-product');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Pengaturan',
            onPressed: () {
              // Navigasi ke halaman pengaturan menggunakan GoRouter
              context.push('/settings');
            },
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(
              child: Text('Anda belum menambahkan produk.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.file(
                        File(product.imagePath),
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported, size: 56),
                      ),
                    ),
                    title: Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Rp ${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(color: AppColors.primary),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          tooltip: 'Edit',
                          onPressed: () {
                            context.push('/edit-product/${product.id}');
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          tooltip: 'Hapus',
                          onPressed: () {
                            // Tampilkan dialog konfirmasi sebelum menghapus
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Konfirmasi Hapus'),
                                content: Text('Apakah Anda yakin ingin menghapus "${product.name}"?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Batal'),
                                    onPressed: () => Navigator.of(ctx).pop(),
                                  ),
                                  TextButton(
                                    child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                    onPressed: () {
                                      // 4. Gunakan ref.read untuk memanggil metode provider
                                      ref.read(productProvider.notifier).deleteProduct(product.id);
                                      Navigator.of(ctx).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Produk berhasil dihapus.')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
