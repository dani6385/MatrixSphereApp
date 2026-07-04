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
  final _listKey = GlobalKey<AnimatedListState>();
  List<Product> _products = [];

  @override
  Widget build(BuildContext context) {
    // Pantau state dari FutureProvider
    final productsAsync = ref.watch(productListProvider);

    // Sinkronkan data lokal saat data dari provider berubah
    productsAsync.whenData((data) => _products = data);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produk Saya'),
        actions: [
          PopupMenuButton<ProductSortType>(
            icon: const Icon(Icons.sort),
            tooltip: 'Urutkan Produk',
            onSelected: (sortType) {
              ref.read(productSortTypeProvider.notifier).state = sortType;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ProductSortType.uploadDateNewest,
                child: Text('Terbaru Diupload'),
              ),
              const PopupMenuItem(
                value: ProductSortType.nameAsc,
                child: Text('Nama (A-Z)'),
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
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cari Produk',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {
                // Perbarui state provider pencarian saat pengguna mengetik
                ref.read(productSearchQueryProvider.notifier).state = query;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 8.0),
            child: SwitchListTile(
              title: const Text('Sembunyikan Stok Habis'),
              value: ref.watch(hideOutOfStockProvider),
              onChanged: (newValue) {
                ref.read(hideOutOfStockProvider.notifier).setFilter(newValue);
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
          Expanded(
            // Gunakan .when() untuk menangani state loading, data, dan error
            child: productsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Terjadi kesalahan: $err')),
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('Tidak ada produk yang ditemukan.'));
                }
                return AnimatedList(
                  key: _listKey,
                  initialItemCount: _products.length,
                  itemBuilder: (context, index, animation) {
                    final product = _products[index];
                    return _buildAnimatedItem(context, product, index, animation);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah produk
          context.push('/add-product');
        },
        tooltip: 'Tambah Produk',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAnimatedItem(BuildContext context, Product product, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Hero(
              tag: 'product_image_${product.id}',
              child: product.imageUrls.isNotEmpty ? Image.network(
                product.imageUrls.first,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
              ) : const SizedBox(width: 50, height: 50, child: Icon(Icons.image_not_supported)),
            ),
            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: _buildStockSubtitle(context, product),
            onTap: () {
              context.push('/product/${product.id}');
            },
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  context.push('/edit-product/${product.id}');
                } else if (value == 'delete') {
                  _deleteProduct(product, index);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
                const PopupMenuItem<String>(value: 'delete', child: Text('Hapus')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteProduct(Product product, int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus "${product.name}"?'),
        actions: [
          TextButton(child: const Text('Batal'), onPressed: () => Navigator.of(ctx).pop(false)),
          TextButton(child: const Text('Hapus', style: TextStyle(color: Colors.red)), onPressed: () => Navigator.of(ctx).pop(true)),
        ],
      ),
    );

    // Setelah `await`, selalu periksa apakah widget masih 'mounted'.
    if (!mounted) return;

    if (confirmed == true) {
      // Hapus item dari daftar lokal dan picu animasi
      _listKey.currentState?.removeItem(
        index,
        (context, animation) => _buildAnimatedItem(context, product, index, animation),
        duration: const Duration(milliseconds: 400),
      );
      _products.removeAt(index);

      try {
        await ref.read(productRepositoryProvider).deleteProduct(product.id);
        // Periksa lagi setelah async call kedua sebelum menggunakan context.
        if (!mounted) return;

        // Muat ulang daftar di latar belakang untuk memastikan konsistensi
        ref.invalidate(productListProvider);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk berhasil dihapus.')));
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus produk: $e')));
      }
    }
  }

  Widget _buildStockSubtitle(BuildContext context, Product product) {
    final priceText = ' • Rp ${product.price.toStringAsFixed(0)}';
    final defaultStyle = Theme.of(context).textTheme.bodyMedium;

    if (product.stock == 0) {
      return RichText(
        text: TextSpan(
          style: defaultStyle,
          children: [
            const TextSpan(text: 'Stok Habis', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            TextSpan(text: priceText),
          ],
        ),
      );
    } else if (product.stock <= 10) {
      return RichText(
        text: TextSpan(
          style: defaultStyle,
          children: [
            TextSpan(text: 'Stok Hampir Habis (${product.stock})', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
            TextSpan(text: priceText),
          ],
        ),
      );
    }
    return Text('Stok: ${product.stock}$priceText');
  }
}
