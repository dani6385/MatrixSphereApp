import 'package:flutter/foundation.dart';
import 'package:seller_sphere/models/product.dart';

final List<Product> _dummyProducts = [
  Product(
      id: '1',
      name: 'Kopi Robusta',
      sku: 'K-001',
      stock: 5,
      purchasePrice: 20000,
      sellingPrice: 25000,
      category: 'Minuman',
      minStockThreshold: 10,
      ageRating: 0,
      description: '',
      price: 0,
      imageUrl: ''),
  Product(
      id: '2',
      name: 'Action Figure Keren',
      sku: 'AF-002',
      stock: 15,
      purchasePrice: 150000,
      sellingPrice: 250000,
      category: 'Mainan',
      minStockThreshold: 5,
      ageRating: 13, description: '', price: 0, imageUrl: ''),
  Product(
      id: '3',
      name: 'Novel Fiksi Ilmiah',
      sku: 'NV-003',
      stock: 30,
      purchasePrice: 75000,
      sellingPrice: 95000,
      category: 'Buku',
      minStockThreshold: 5,
      ageRating: 18, description: '', price: 0, imageUrl: ''),
];

class InventoryProvider with ChangeNotifier {
  // --- Private State ---
  List<Product> _products = [];
  String _searchQuery = "";
  String _selectedCategory = "Semua";
  String _selectedSortKey = "Alphabetical";
  bool _isSafeModeEnabled = false;
  int _safeModeAgeLimit = 0; // 0: Semua, 13: Remaja, 18: Dewasa

  // --- Public Getters ---
  List<Product> get products => _products;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  String get selectedSortKey => _selectedSortKey;
  bool get isSafeModeEnabled => _isSafeModeEnabled;
  int get safeModeAgeLimit => _safeModeAgeLimit;

  final Map<String, String> sortOptions = {
    "Alphabetical": "A-Z",
    "Stock Level (Low to High)": "Stok",
    "Price": "Harga",
  };

  InventoryProvider() {
    _loadProducts();
  }

  void _loadProducts() {
    // In a real app, this would come from a service or database
    _products = _dummyProducts;
    notifyListeners();
  }

  // --- Computed Properties ---
  List<Product> get filteredAndSortedProducts {
    final filtered = _products.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.sku.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == "Semua" || p.category == _selectedCategory;
      final matchesSafeMode =
          !_isSafeModeEnabled || p.ageRating <= _safeModeAgeLimit;
      return matchesSearch && matchesCategory && matchesSafeMode;
    }).toList();

    switch (_selectedSortKey) {
      case "Stock Level (Low to High)":
        filtered.sort((a, b) => a.stock.compareTo(b.stock));
        break;
      case "Price":
        filtered.sort((a, b) => a.sellingPrice.compareTo(b.sellingPrice));
        break;
      case "Alphabetical":
      default:
        filtered.sort(
            (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
    }
    return filtered;
  }

  List<String> get categories {
    return ["Semua", ..._products.map((p) => p.category).toSet().toList()];
  }

  int get lowStockCount {
    return _products.where((p) => p.stock < p.minStockThreshold).length;
  }

  // --- Utility ---
  String formatRupiah(int price) {
    return "Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  // --- Mutators (Actions) ---
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void updateCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updateSortKey(String sortKey) {
    _selectedSortKey = sortKey;
    notifyListeners();
  }

  void setSafeMode(bool enabled) {
    _isSafeModeEnabled = enabled;
    notifyListeners();
  }

  void setSafeModeAgeLimit(int age) {
    _safeModeAgeLimit = age;
    notifyListeners();
  }

  void deleteProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}
