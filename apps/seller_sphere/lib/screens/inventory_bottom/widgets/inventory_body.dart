// lib/screens/inventory_bottom/widgets/inventory_body.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/screens/inventory_bottom/bloc/product_bloc.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

class InventoryBody extends StatelessWidget {
  const InventoryBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        // Tampilkan loading indicator saat data sedang dimuat
        if (state.status == ProductStatus.loading && state.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Tampilkan pesan error jika terjadi kegagalan
        if (state.status == ProductStatus.failure) {
          return Center(
            child: Text('Gagal memuat data: ${state.error}'),
          );
        }

        // Tampilkan pesan jika tidak ada produk
        if (state.products.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada produk.\nTekan tombol + untuk menambah produk baru.',
              textAlign: TextAlign.center,
            ),
          );
        }

        // Tampilkan daftar produk jika berhasil
        return ListView.builder(
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            final product = state.products[index];
            return _ProductListItem(product: product);
          },
        );
      },
    );
  }
}

class _ProductListItem extends StatelessWidget {
  const _ProductListItem({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage:
              product.imageUrl != null ? NetworkImage(product.imageUrl!) : null,
          child: product.imageUrl == null
              ? Text(product.name.isNotEmpty ? product.name[0] : '?')
              : null,
        ),
        title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('SKU: ${product.sku}\nStok: ${product.stock}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: kAccentPurple),
              onPressed: () {
                context.go('/inventory/edit', extra: product);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: kWarmOrange),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Konfirmasi Hapus'),
                    content: Text('Anda yakin ingin menghapus "${product.name}"?'),
                    actions: [
                      TextButton(
                        child: const Text('Batal'),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      TextButton(
                        child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          context.read<ProductBloc>().add(ProductDeleted(product));
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}