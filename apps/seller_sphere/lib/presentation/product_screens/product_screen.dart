// d:\MatrixSphereApp\apps\seller_sphere\lib\presentation\product_screens\product_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/presentation/product_screens/providers/product_provider.dart';

import 'models/product_model.dart';
 
class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    // 1. Pantau state dari Notifier.
    final productListState = ref.watch(productListNotifierProvider);
    // Dapatkan instance notifier untuk memanggil method.
    final productListNotifier = ref.read(productListNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk Saya'),
        actions: [
          // Tombol Tambah Produk
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Produk',
            onPressed: () => context.push('/add-product'),
          ),
          // Tombol Urutkan
          PopupMenuButton<ProductSortType>(
            icon: const Icon(Icons.sort),
            tooltip: 'Urutkan Produk',
            // 2. Panggil method `updateSortType` dari notifier.
            onSelected: productListNotifier.updateSortType,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ProductSortType.uploadDateNewest,
                child: Text('Terbaru Diupload'),
              ),
              const PopupMenuItem(
                value: ProductSortType.uploadDateOldest,
                child: Text('Terlama Diupload'),
              ),
              const PopupMenuItem(
                value: ProductSortType.nameAsc,
                child: Text('Nama (A-Z)'),
              ),
              const PopupMenuItem(
                value: ProductSortType.nameDesc,
                child: Text('Nama (Z-A)'),
              ),
              const PopupMenuItem(
                value: ProductSortType.priceAsc,
                child: Text('Harga (Termurah)'),
              ),
              const PopupMenuItem(
                value: ProductSortType.priceDesc,
                child: Text('Harga (Termahal)'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cari Produk',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              ),
              // 3. Panggil method `updateSearchQuery` dari notifier.
              onChanged: productListNotifier.updateSearchQuery,
            ),
          ),
          Expanded(
            child: _buildProductList(context, ref, productListState),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-product'),
        tooltip: 'Tambah Produk',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductList(
      BuildContext context, WidgetRef ref, ProductListState state) {
    if (state.status == ProductListStatus.loading && state.allProducts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ProductListStatus.error) {
      return Center(child: Text('Terjadi kesalahan: ${state.errorMessage}'));
    }

    // Buat map untuk lookup produk dengan cepat berdasarkan ID
    final productMap = {for (var p in state.allProducts) p.id: p};
    // Ambil daftar produk yang sudah difilter dan diurutkan
    final filteredProducts =
        state.filteredProductIds.map((id) => productMap[id]!).toList();

    if (filteredProducts.isEmpty) {
      return Center(
        child: Text(state.searchQuery.isEmpty
            ? 'Anda belum memiliki produk.'
            : 'Produk tidak ditemukan.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80), // Padding untuk FAB
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        return _ProductListItem(
          product: product,
          onDelete: () => _deleteProduct(ref, product),
        );
      },
    );
  }

  Future<void> _deleteProduct(
      WidgetRef ref, Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus "${product.name}"?'),
        actions: [
          TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(ctx).pop(false)),
          TextButton(
              child: const Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(ctx).pop(true)),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final repo = ref.read(productRepositoryProvider);
        await repo.deleteProduct(product.id);
        if (!mounted) return; // Guard clause
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk berhasil dihapus.')));
        // Data akan otomatis refresh karena kita menggunakan stream.
      } catch (e) {
        if (!mounted) return; // Guard clause
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus produk: $e')));
      }
    }
  }
}

class _ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  const _ProductListItem({required this.product, required this.onDelete});

  Widget _buildStockSubtitle(BuildContext context, Product product) {
    final priceText = ' • Rp ${product.price.toStringAsFixed(0)}';
    final defaultStyle = Theme.of(context).textTheme.bodyMedium;

    if (product.stock == 0) {
      return RichText(
        text: TextSpan(
          style: defaultStyle?.copyWith(color: Colors.grey[600]),
          children: [
            const TextSpan(
                text: 'Stok Habis',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            TextSpan(text: priceText),
          ],
        ),
      );
    } else if (product.stock <= 10) {
      return RichText(
        text: TextSpan(
          style: defaultStyle?.copyWith(color: Colors.grey[600]),
          children: [
            TextSpan(
                text: 'Stok Hampir Habis (${product.stock})',
                style: const TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold)),
            TextSpan(text: priceText),
          ],
        ),
      );
    }
    return Text('Stok: ${product.stock}$priceText',
        style: defaultStyle?.copyWith(color: Colors.grey[600]));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Hero(
          tag: 'product_image_${product.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: product.imageUrls.isNotEmpty
                ? Image.network(
                    product.imageUrls.first,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported, size: 56),
                  )
                : Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported)),
          ),
        ),
        title: Text(product.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: _buildStockSubtitle(context, product),
        onTap: () {
          context.push('/product/${product.id}');
        },
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              context.push('/edit-product/${product.id}');
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
            const PopupMenuItem<String>(value: 'delete', child: Text('Hapus')),
          ],
        ),
      ),
    );
  }
}
