import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository untuk mengelola data produk.
/// Di aplikasi nyata, ini akan berkomunikasi dengan API.
class ProductRepository {
  // Data dummy yang akan kita gunakan untuk simulasi panggilan API.
  static final List<Product> _dummyProducts = [
    Product(
        id: 'p1',
        name: 'Sepatu Lari Keren',
        imageUrls: ['https://via.placeholder.com/400x300/FF5733/FFFFFF', 'https://via.placeholder.com/400x300/33FF57/FFFFFF', 'https://via.placeholder.com/400x300/3357FF/FFFFFF'],
        price: 750000,
        stock: 15,
        createdAt: DateTime.now().subtract(const Duration(days: 2))),
    Product(
        id: 'p2',
        name: 'Kaos Polos Premium',
        imageUrls: ['https://via.placeholder.com/400x300/F4D03F/FFFFFF'],
        price: 120000,
        stock: 50,
        createdAt: DateTime.now().subtract(const Duration(days: 5))),
    Product(
        id: 'p3',
        name: 'Jam Tangan Digital',
        imageUrls: ['https://via.placeholder.com/400x300/8E44AD/FFFFFF', 'https://via.placeholder.com/400x300/AD448E/FFFFFF'],
        price: 350000,
        stock: 22,
        createdAt: DateTime.now().subtract(const Duration(hours: 10))),
    Product(
        id: 'p4',
        name: 'Topi Baseball',
        imageUrls: ['https://via.placeholder.com/400x300/16A085/FFFFFF'],
        price: 85000,
        stock: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 1))),
  ];

  /// Mensimulasikan pengambilan data produk dari API.
  Future<List<Product>> fetchProducts() async {
    // Tambahkan delay untuk mensimulasikan latensi jaringan.
    await Future.delayed(const Duration(seconds: 2));
    // Di sini Anda akan menggantinya dengan panggilan http.get(...)
    return List<Product>.from(_dummyProducts); // Kembalikan salinan agar tidak termutasi
  }

  /// Mensimulasikan pengambilan data satu produk berdasarkan ID.
  Future<Product> fetchProductById(String id) async {
    // Tambahkan delay untuk mensimulasikan latensi jaringan.
    await Future.delayed(const Duration(milliseconds: 500));
    // Di aplikasi nyata, ini akan menjadi panggilan API ke endpoint seperti /api/products/{id}
    try {
      return _dummyProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      throw Exception('Produk dengan ID $id tidak ditemukan.');
    }
  }

  /// Mensimulasikan penambahan produk baru ke API.
  Future<Product> addProduct(Product product, {List<String>? imagePaths}) async {
    await Future.delayed(const Duration(seconds: 1));
    // Di aplikasi nyata, Anda akan mengunggah gambar dan mendapatkan URL.
    final newProduct = Product(
      id: 'p${Random().nextInt(1000)}', // Buat ID acak
      name: product.name,
      price: product.price,
      stock: product.stock,
      imageUrls: imagePaths?.isNotEmpty == true ? ['https://via.placeholder.com/150/new'] : ['https://via.placeholder.com/150/no-image'],
      createdAt: DateTime.now(),
    );
    _dummyProducts.insert(0, newProduct);
    return newProduct;
  }

  /// Mensimulasikan pembaruan produk yang ada di API.
  Future<void> updateProduct(Product product, {List<String>? imagePaths}) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _dummyProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      // Di aplikasi nyata, Anda akan mengunggah gambar baru jika ada.
      final updatedProduct = Product(
        id: product.id,
        name: product.name,
        price: product.price,
        stock: product.stock,
        imageUrls: imagePaths?.isNotEmpty == true ? ['https://via.placeholder.com/150/updated'] : product.imageUrls,
        createdAt: product.createdAt, // Pertahankan tanggal pembuatan asli
      );
      _dummyProducts[index] = updatedProduct;
    }
  }

  /// Mensimulasikan penghapusan produk dari API.
  Future<void> deleteProduct(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _dummyProducts.removeWhere((product) => product.id == id);
    // Di aplikasi nyata, Anda akan membuat permintaan HTTP DELETE.
  }
}

// 1. Provider untuk instance ProductRepository.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

// 2. StateProvider untuk menyimpan query pencarian.
final productSearchQueryProvider = StateProvider<String>((ref) => '');

// 3. Enum dan Provider untuk tipe pengurutan
enum ProductSortType {
  uploadDateNewest,
  uploadDateOldest,
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
}

final productSortTypeProvider = StateProvider<ProductSortType>((ref) => ProductSortType.uploadDateNewest);

// 4. Notifier dan Provider untuk filter stok habis dengan persistensi
class HideOutOfStockNotifier extends StateNotifier<bool> {
  static const _key = 'HIDE_OUT_OF_STOCK';

  HideOutOfStockNotifier() : super(false) {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }

  Future<void> setFilter(bool isHidden) async {
    state = isHidden;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, isHidden);
  }
}

final hideOutOfStockProvider = StateNotifierProvider<HideOutOfStockNotifier, bool>((ref) => HideOutOfStockNotifier());

// 5. FutureProvider utama yang akan mengambil, memfilter, dan mengurutkan produk.
final productListProvider = FutureProvider<List<Product>>((ref) async {
  // Ambil repository dan semua state filter/sort.
  final repository = ref.watch(productRepositoryProvider);
  final searchQuery = ref.watch(productSearchQueryProvider);
  final sortType = ref.watch(productSortTypeProvider);
  final hideOutOfStock = ref.watch(hideOutOfStockProvider);

  // Ambil semua produk dari "API".
  final allProducts = await repository.fetchProducts();

  // Terapkan filter
  List<Product> filteredProducts = allProducts
      .where((product) =>
          product.name.toLowerCase().contains(searchQuery.toLowerCase()) &&
          (!hideOutOfStock || product.stock > 0))
      .toList();

  // Terapkan logika pengurutan
  switch (sortType) {
    case ProductSortType.uploadDateNewest:
      filteredProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case ProductSortType.uploadDateOldest:
      filteredProducts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
    case ProductSortType.nameAsc:
      filteredProducts.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      break;
    case ProductSortType.nameDesc:
      filteredProducts.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
      break;
    case ProductSortType.priceAsc:
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
      break;
    case ProductSortType.priceDesc:
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
      break;
  }

  return filteredProducts;
});

// 6. FutureProvider.family untuk mengambil detail satu produk berdasarkan ID.
final productDetailProvider =
    FutureProvider.family<Product, String>((ref, productId) async {
  final repository = ref.watch(productRepositoryProvider);
  return await repository.fetchProductById(productId);
});

// 7. Provider untuk menangani state saat proses simpan/update.
final productMutationProvider = StateProvider<bool>((ref) {
  // false = tidak sedang loading, true = sedang loading
  return false;
});