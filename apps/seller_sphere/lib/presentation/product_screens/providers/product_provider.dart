import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

final logger = Logger();

/// Repository untuk mengelola data produk.
/// Repository ini berkomunikasi langsung dengan Cloud Firestore.
class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository(this._firestore);

  // Mendapatkan referensi ke koleksi 'products' di Firestore.
  CollectionReference<Product> get _productsRef => _firestore
      .collection('products')
      .withConverter<Product>(
        fromFirestore: (snapshot, _) =>
            Product.fromMap(snapshot.data()!, snapshot.id),
        toFirestore: (product, _) => product.toMap(),
      );

  /// Menyediakan stream data produk dari Firestore secara real-time.
  /// Setiap kali ada perubahan di koleksi, stream ini akan mengirimkan daftar produk terbaru.
  Stream<List<Product>> watchProducts() {
    try {
      return _productsRef
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) => doc.data()).toList();
          });
    } catch (e) {
      logger.e('Error fetching products: $e');
      return Stream.error(e);
    }
  }

  /// Mengambil data satu produk berdasarkan ID dari Firestore.
  Future<Product> fetchProductById(String id) async {
    try {
      final doc = await _productsRef.doc(id).get();
      if (!doc.exists) {
        throw Exception('Produk dengan ID $id tidak ditemukan.');
      }
      return doc.data()!;
    } catch (e) {
      logger.e('Error fetching product by ID: $e');
      rethrow;
    }
  }

  /// Menambahkan produk baru ke Firestore.
  Future<Product> addProduct(
    Product product, {
    List<String>? imagePaths,
  }) async {
    try {
      // Di aplikasi nyata, Anda akan mengunggah gambar ke Firebase Storage
      // dan mendapatkan URL-nya sebelum menyimpan ke Firestore.
      // Untuk saat ini, kita gunakan placeholder.
      final imageUrls = imagePaths?.isNotEmpty == true
          ? ['https://via.placeholder.com/150/new']
          : ['https://via.placeholder.com/150/no-image'];

      // Buat dokumen baru di Firestore. Firestore akan meng-generate ID unik.
      final docRef = _productsRef.doc();

      final newProduct = Product(
        id: docRef.id, // Gunakan ID dari Firestore
        name: product.name,
        price: product.price,
        stock: product.stock,
        imageUrls: imageUrls,
        createdAt: DateTime.now(), // Timestamp sisi klien
      );

      // Kirim data ke Firestore
      await docRef.set(newProduct);

      return newProduct;
    } catch (e) {
      logger.e('Error adding product: $e');
      rethrow;
    }
  }

  /// Memperbarui produk yang ada di Firestore.
  Future<void> updateProduct(
    Product product, {
    List<String>? imagePaths,
  }) async {
    try {
      // Siapkan data yang akan di-update.
      // Menggunakan Map lebih efisien untuk update parsial.
      final updateData = {
        'name': product.name,
        'price': product.price,
        'stock': product.stock,
        // Tambahkan logika upload gambar dan update URL jika ada
        // 'imageUrls': newImageUrls,
      };

      await _productsRef.doc(product.id).update(updateData);
    } catch (e) {
      logger.e('Error updating product: $e');
      rethrow;
    }
  }

  /// Menghapus produk dari Firestore.
  Future<void> deleteProduct(String id) async {
    try {
      await _productsRef.doc(id).delete();
    } catch (e) {
      logger.e('Error deleting product: $e');
      rethrow;
    }
  }
}

// 1. Provider untuk instance ProductRepository.
// Kita juga perlu menyediakan instance Firestore.
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  // Inject Firestore instance ke dalam repository.
  return ProductRepository(ref.watch(firestoreProvider));
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
  StreamSubscription<List<Product>>? _productsSubscription;
  static const _hideStockKey = 'HIDE_OUT_OF_STOCK';

  ProductListNotifier(this._repository) : super(const ProductListState()) {
    _loadInitialFilters();
    _listenToProducts();
  }

  Future<void> _loadInitialFilters() async {
    final prefs = await SharedPreferences.getInstance();
    final hide = prefs.getBool(_hideStockKey) ?? false;
    state = state.copyWith(hideOutOfStock: hide);
  }

  void _listenToProducts() {
    state = state.copyWith(status: ProductListStatus.loading);
    _productsSubscription?.cancel(); // Batalkan listener sebelumnya jika ada
    _productsSubscription = _repository.watchProducts().listen(
      (products) {
        state = state.copyWith(
          allProducts: products,
          status: ProductListStatus.success,
        );
        _applyFiltersAndSort();
      },
      onError: (e) {
        state = state.copyWith(
          status: ProductListStatus.error,
          errorMessage: e.toString(),
        );
      },
    );
  }

  @override
  void dispose() {
    // Pastikan untuk membatalkan subscription saat notifier tidak lagi digunakan
    _productsSubscription?.cancel();
    super.dispose();
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
      final searchMatch = product.name.toLowerCase().contains(
        state.searchQuery.toLowerCase(),
      );
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
        filteredProducts.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
        break;
      case ProductSortType.nameDesc:
        filteredProducts.sort(
          (a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
        );
        break;
      case ProductSortType.priceAsc:
        filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortType.priceDesc:
        filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
    }

    state = state.copyWith(
      filteredProductIds: filteredProducts.map((p) => p.id).toList(),
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFiltersAndSort();
  }
}

// 6. Provider utama yang akan digunakan di UI
final productListNotifierProvider =
    StateNotifierProvider<ProductListNotifier, ProductListState>((ref) {
      return ProductListNotifier(ref.watch(productRepositoryProvider));
    });

// 7. FutureProvider.family untuk mengambil detail satu produk berdasarkan ID.
// Provider ini tetap berguna karena ia menangani caching per-ID secara otomatis.
final productDetailProvider = FutureProvider.family<Product, String>((
  ref,
  productId,
) async {
  // Optimasi: Cek apakah produk sudah ada di state notifier
  final productListState = ref.watch(productListNotifierProvider);
  if (productListState.status == ProductListStatus.success) {
    try {
      final product = productListState.allProducts.firstWhere(
        (p) => p.id == productId,
      );
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
