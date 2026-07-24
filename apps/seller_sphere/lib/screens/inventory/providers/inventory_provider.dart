import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/services/product_service.dart';
import 'package:shared_services/shared_services.dart';

class InventoryProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  StreamSubscription? _productsSubscription;

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  int _safeModeAgeLimit = 0; // 0 for SU, 13 for 13+, 18 for 18+
  bool _isSafeModeEnabled = false;

  final List<String> _categories = ['Semua', 'Elektronik', 'Pakaian', 'Makanan', 'Minuman', 'Otomotif', 'Rumah Tangga'];

  final Map<String, String> _sortOptions = {
    'name_asc': 'Nama (A-Z)',
    'name_desc': 'Nama (Z-A)',
    'price_asc': 'Harga (Termurah)',
    'price_desc': 'Harga (Termahal)',
    'stock_asc': 'Stok (Terendah)',
    'stock_desc': 'Stok (Tertinggi)',
  };
  String _selectedSortKey = 'name_asc';

  InventoryProvider() {
    _listenToProducts();
  }

  List<Product> get products => _filteredProducts;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  List<String> get categories => _categories;
  Map<String, String> get sortOptions => _sortOptions;
  String get selectedSortKey => _selectedSortKey;
  int get safeModeAgeLimit => _safeModeAgeLimit;
  bool get isSafeModeEnabled => _isSafeModeEnabled;
  List<Product> get filteredAndSortedProducts => _filteredProducts;
  String formatRupiah(double value) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(value);
  }

  Future<void> addProduct(Product product) async {
    await _productService.addProduct(product);
  }

  Future<void> updateProduct(Product product) async {
    await _productService.updateProduct(product);
  }

  Future<void> deleteProduct(String productId) async {
    await _productService.deleteProduct(productId);
  }

  Future<String> uploadImageToImgBB({required String imagePath}) async {
    return await _productService.uploadImageToImgBB(imagePath: imagePath);
  }
  

  void _listenToProducts() {
    _productsSubscription = _productService.getProducts().listen((products) {
      _products = products;
      _applyFiltersAndSort();
    });
  }

  void updateSearchQuery(String query) {    _searchQuery = query;
    _applyFiltersAndSort();
  }

  void updateCategory(String category) {
    _selectedCategory = category;
    _applyFiltersAndSort();
  }

  void updateSortKey(String sortKey) {
    _selectedSortKey = sortKey;
    _applyFiltersAndSort();
  }

  void setSafeMode(bool value) {
    _isSafeModeEnabled = value;
    _applyFiltersAndSort();
  }

  void setSafeModeAgeLimit(int limit) {
    _safeModeAgeLimit = limit;
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<Product> tempProducts = List.from(_products);

    // Apply search query filter
    if (_searchQuery.isNotEmpty) {
      tempProducts = tempProducts
          .where((product) =>
              product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != 'Semua') {
      tempProducts = tempProducts
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    // Apply safe mode filter
    if (_isSafeModeEnabled) {
      tempProducts = tempProducts
          .where((product) => product.ageRating <= _safeModeAgeLimit)
          .toList();
    }

    // Apply sorting
    switch (_selectedSortKey) {
      case 'name_asc':
        tempProducts.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name_desc':
        tempProducts.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'price_asc':
        tempProducts.sort((a, b) => a.sellingPrice.compareTo(b.sellingPrice));
        break;
      case 'price_desc':
        tempProducts.sort((a, b) => b.sellingPrice.compareTo(a.sellingPrice));
        break;
      case 'stock_asc':
        tempProducts.sort((a, b) => a.stock.compareTo(b.stock));
        break;
      case 'stock_desc':
        tempProducts.sort((a, b) => b.stock.compareTo(a.stock));
        break;
    }

    _filteredProducts = tempProducts;
    notifyListeners();
  }

  @override
  void dispose() {
    _productsSubscription?.cancel();
    super.dispose();
  }
  int get lowStockCount {
    return _products.where((product) => product.stock < product.minStockThreshold).length;
  }
  int get totalStock {
    return _products.fold<int>(0, (sum, product) => sum + product.stock);
  }

  double get totalInventoryValue {
    return _products.fold<double>(
        0.0, (sum, product) => sum + (product.sellingPrice * product.stock));
  }
  int get totalProducts => _products.length;
}