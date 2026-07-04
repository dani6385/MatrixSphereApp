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

// --- State Notifier untuk Daftar Produk ---

// 2. Enum untuk status state
enum ProductListStatus { initial, loading, success, error }

// 3. Enum untuk tipe pengurutan
enum ProductSortType {
  uploadDateNewest,
  uploadDateOldest,
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
}

// 4. Class untuk menampung state
class ProductListState {
  final ProductListStatus status;
  final List<Product> allProducts;
  final List<String> filteredProductIds;
  final String? errorMessage;
  final String searchQuery;
  final ProductSortType sortType;
  final bool hideOutOfStock;

  const ProductListState({
    this.status = ProductListStatus.initial,
    this.allProducts = const [],
    this.filteredProductIds = const [],
    this.errorMessage,
    this.searchQuery = '',
    this.sortType = ProductSortType.uploadDateNewest,
    this.hideOutOfStock = false,
  });

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? allProducts,
    List<String>? filteredProductIds,
    String? errorMessage,
    String? searchQuery,
    ProductSortType? sortType,
    bool? hideOutOfStock,
  }) {
    return ProductListState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      filteredProductIds: filteredProductIds ?? this.filteredProductIds,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      sortType: sortType ?? this.sortType,
      hideOutOfStock: hideOutOfStock ?? this.hideOutOfStock,
    );
  }
}

// 5. StateNotifier yang mengelola semua logika
class ProductListNotifier extends StateNotifier<ProductListState> {
  final ProductRepository _repository;
  static const _hideStockKey = 'HIDE_OUT_OF_STOCK';

  ProductListNotifier(this._repository) : super(const ProductListState()) {
    _loadInitialFilters();
    fetchProducts();
  }

  Future<void> _loadInitialFilters() async {
    final prefs = await SharedPreferences.getInstance();
    final hide = prefs.getBool(_hideStockKey) ?? false;
    state = state.copyWith(hideOutOfStock: hide);
  }

  Future<void> fetchProducts() async {
    state = state.copyWith(status: ProductListStatus.loading);
    try {
      final products = await _repository.fetchProducts();
      state = state.copyWith(allProducts: products, status: ProductListStatus.success);
      _applyFiltersAndSort();
    } catch (e) {
      state = state.copyWith(status: ProductListStatus.error, errorMessage: e.toString());
    }
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFiltersAndSort();
  }

  void updateSortType(ProductSortType sortType) {
    state = state.copyWith(sortType: sortType);
    _applyFiltersAndSort();
  }

  Future<void> updateHideOutOfStock(bool hide) async {
    state = state.copyWith(hideOutOfStock: hide);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hideStockKey, hide);
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    if (state.status != ProductListStatus.success) return;

    // Terapkan filter
    List<Product> filteredProducts = state.allProducts.where((product) {
      final searchMatch = product.name.toLowerCase().contains(state.searchQuery.toLowerCase());
      final stockMatch = !state.hideOutOfStock || product.stock > 0;
      return searchMatch && stockMatch;
    }).toList();

    // Terapkan logika pengurutan
    switch (state.sortType) {
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

    state = state.copyWith(filteredProductIds: filteredProducts.map((p) => p.id).toList());
  }
}

// 6. Provider utama yang akan digunakan di UI
final productListNotifierProvider = StateNotifierProvider<ProductListNotifier, ProductListState>((ref) {
  return ProductListNotifier(ref.watch(productRepositoryProvider));
});

// 7. FutureProvider.family untuk mengambil detail satu produk berdasarkan ID.
// Provider ini tetap berguna karena ia menangani caching per-ID secara otomatis.
final productDetailProvider = FutureProvider.family<Product, String>((ref, productId) async {
  // Optimasi: Cek apakah produk sudah ada di state notifier
  final productListState = ref.watch(productListNotifierProvider);
  if (productListState.status == ProductListStatus.success) {
    try {
      final product = productListState.allProducts.firstWhere((p) => p.id == productId);
      return product;
    } catch (_) {
      // Jika tidak ditemukan, fallback ke fetch dari repository
    }
  }
  
  final repository = ref.read(productRepositoryProvider);
  return await repository.fetchProductById(productId);
});

// 8. Provider untuk menangani state saat proses simpan/update.
final productMutationProvider = StateProvider<bool>((ref) {
  // false = tidak sedang loading, true = sedang loading
  return false;
});