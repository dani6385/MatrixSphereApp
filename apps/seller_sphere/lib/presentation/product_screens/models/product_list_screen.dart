import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async'; // Impor untuk menggunakan Timer
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
//import 'package:seller_sphere/presentation/product_screens/models/product_model.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:seller_sphere/presentation/product_screens/providers/product_provider.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  bool _isSearching = false;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Sinkronkan controller dengan state dari notifier
    _searchController.text = ref.read(productListNotifierProvider).searchQuery;
    _searchController.addListener(() {
      // Batalkan timer sebelumnya jika ada
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      // Mulai timer baru
      _debounce = Timer(const Duration(milliseconds: 500), () {
        // Panggil metode update di notifier hanya setelah delay
        // Pastikan teks di controller tidak sama dengan state untuk menghindari pembaruan yang tidak perlu
        if (ref.read(productListNotifierProvider).searchQuery != _searchController.text) {
          ref.read(productListNotifierProvider.notifier).updateSearchQuery(_searchController.text);
        }
      });
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _debounce?.cancel(); // Batalkan timer saat widget di-dispose
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        _searchFocusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pantau satu provider utama untuk semua state UI
    final productListState = ref.watch(productListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Cari produk...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              )
            : const Text('Daftar Produk'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            tooltip: 'Cari Produk',
            onPressed: _toggleSearch,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter & Urutkan',
            onPressed: () => _showFilterSortDialog(context),
          ),
        ],
      ),
      body: () { // Gunakan closure untuk logika switch
        switch (productListState.status) {
          case ProductListStatus.initial:
          case ProductListStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ProductListStatus.error:
            return Center(child: Text('Error: ${productListState.errorMessage}'));
          case ProductListStatus.success:
            if (productListState.filteredProductIds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Anda belum memiliki produk.'),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Produk'),
                    onPressed: () => context.push('/add-product'),
                  )
                ],
              ),
            );
            }
            // Gunakan AnimatedSwitcher untuk transisi yang mulus saat daftar produk berubah.
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: AnimationLimiter(
                // Berikan key unik berdasarkan hashcode dari daftar produk.
                // Ini memberitahu AnimatedSwitcher kapan harus menganimasikan perubahan.
                key: ValueKey(productListState.filteredProductIds.hashCode),
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: productListState.filteredProductIds.length,
                  itemBuilder: (context, index) {
                    final productId = productListState.filteredProductIds[index];
                    return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _ProductListItem(productId: productId),
                      ),
                    ),
                    );
                  },
                ),
              ),
            );
        }
      }(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah produk. Rute ini sudah benar.
          context.push('/add-product');
        },
        tooltip: 'Tambah Produk',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterSortDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const _FilterSortSheet(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
}

/// Widget terpisah untuk setiap item produk dalam daftar.
/// Ini adalah ConsumerWidget sehingga hanya akan membangun ulang dirinya sendiri
/// saat data produk spesifiknya berubah.
class _ProductListItem extends ConsumerWidget {
  final String productId;

  const _ProductListItem({required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau provider detail produk untuk ID spesifik ini.
    final productAsync = ref.watch(productDetailProvider(productId));
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return productAsync.when(
      // Tampilkan placeholder saat data produk sedang dimuat (jarang terjadi, tapi best practice)
      loading: () => const Card(child: ListTile(title: Text('Memuat...'))),
      // Tampilkan error jika produk spesifik ini gagal dimuat
      error: (err, stack) => Card(child: ListTile(title: Text('Error: $err'), subtitle: Text(productId))),
      // Tampilkan data produk
      data: (product) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: () => context.push('/product-detail/${product.id}'),
          leading: Hero(
            tag: 'product_image_${product.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: product.imageUrls.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: product.imageUrls.first,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.image_not_supported, size: 56),
                    )
                  : const Icon(Icons.image_not_supported, size: 56),
            ),
          ),
          title: Text(
            product.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            currencyFormatter.format(product.price),
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Stok: ${product.stock}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: product.stock > 0 ? Colors.green.shade700 : Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    context.push('/edit-product/${product.id}');
                  } else if (value == 'delete') {
                    // Panggil dialog hapus dari state induk
                    _showDeleteConfirmationDialog(context, ref, product.id, product.name);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: ListTile(leading: Icon(Icons.edit), title: Text('Edit')),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: ListTile(leading: Icon(Icons.delete), title: Text('Hapus')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref, String productId, String productName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus produk "$productName"?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Hapus'),
            onPressed: () async {
              Navigator.of(ctx).pop(); // Tutup dialog
              try {
                // Panggil metode delete dari repository
                await ref.read(productRepositoryProvider).deleteProduct(productId);
                // Panggil fetch ulang di notifier
                ref.read(productListNotifierProvider.notifier).fetchProducts();
                // Tampilkan notifikasi sukses
                if (context.mounted) {
                  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                    SnackBar(content: Text('"$productName" berhasil dihapus.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(
                    SnackBar(content: Text('Gagal menghapus produk: $e'), backgroundColor: Theme.of(context).colorScheme.error),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

/// Widget untuk menampilkan opsi filter dan urutan di dalam BottomSheet.
class _FilterSortSheet extends ConsumerWidget {
  const _FilterSortSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ambil state filter/sort langsung dari notifier
    final productListState = ref.watch(productListNotifierProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text('Filter & Urutkan', style: Theme.of(context).textTheme.titleLarge),
          const Divider(height: 24),
          SwitchListTile(
            title: const Text('Sembunyikan Stok Habis'),
            value: productListState.hideOutOfStock,
            onChanged: (value) {
              ref.read(productListNotifierProvider.notifier).updateHideOutOfStock(value);
            },
          ),
          const Divider(height: 24),
          Text('Urutkan Berdasarkan', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _buildSortOption(ref, 'Tanggal (Terbaru)', ProductSortType.uploadDateNewest, productListState.sortType),
          _buildSortOption(ref, 'Tanggal (Terlama)', ProductSortType.uploadDateOldest, productListState.sortType),
          _buildSortOption(ref, 'Nama (A-Z)', ProductSortType.nameAsc, productListState.sortType),
          _buildSortOption(ref, 'Nama (Z-A)', ProductSortType.nameDesc, productListState.sortType),
          _buildSortOption(ref, 'Harga (Termurah)', ProductSortType.priceAsc, productListState.sortType),
          _buildSortOption(ref, 'Harga (Termahal)', ProductSortType.priceDesc, productListState.sortType),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Tutup'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  Widget _buildSortOption(WidgetRef ref, String title, ProductSortType value, ProductSortType groupValue) {
    return RadioListTile<ProductSortType>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: (newValue) {
        if (newValue != null) {
          ref.read(productListNotifierProvider.notifier).updateSortType(newValue);
        }
      },
      contentPadding: EdgeInsets.zero,
    );
  }
}
