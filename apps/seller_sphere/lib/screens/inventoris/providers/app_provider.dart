import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';
import 'package:logger/logger.dart';
// Impor pustaka lain yang diperlukan untuk logika bisnis
// import 'package:csv/csv.dart';
// import 'package:http/http.dart' as http;
final Logger logger = Logger();

class AppProvider with ChangeNotifier {
  final List<Product> _products = [
    // Data contoh awal
    Product(
        id: '1',
        name: 'Kopi Robusta',
        sku: 'K-001',
        stock: 5,
        purchasePrice: 20000,
        sellingPrice: 25000,
        category: 'Minuman',
        minStockThreshold: 10,
        imageUrls: ['https://i.ibb.co/3kC3NfV/product-coffee.jpg'],
 ageRating: 0, description: '', price: 0, imageUrl: ''),
    Product(
        id: '2',
        name: 'Action Figure Keren',
        sku: 'AF-002',
        stock: 15,
        purchasePrice: 150000,
        sellingPrice: 250000,
        category: 'Mainan',
        minStockThreshold: 5,
        imageUrls: ['https://i.ibb.co/9vM5zB2/product-figure.jpg'],
        ageRating: 13,
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', description: '', price: 0, imageUrl: ''),
    Product(
        id: '3',
        name: 'Novel Fiksi Ilmiah',
        sku: 'NV-003',
        stock: 30,
        purchasePrice: 75000,
        sellingPrice: 95000,
        category: 'Buku',
        minStockThreshold: 5,
        imageUrls: [],
        ageRating: 18, description: '', price: 0, imageUrl: ''),
  ];
  List<Product> get products => _products;

  bool _isSafeModeEnabled = false;
  bool get isSafeModeEnabled => _isSafeModeEnabled;

  int _safeModeAgeLimit = 0;
  int get safeModeAgeLimit => _safeModeAgeLimit;

  Product? _selectedProductForLabel;
  Product? get selectedProductForLabel => _selectedProductForLabel;

  // --- Formatters ---
  final NumberFormat _rupiahFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  String formatRupiah(double value) => _rupiahFormat.format(value);

  // --- Logika Bisnis (disederhanakan) ---

  void addProduct(
      String name,
      String sku,
      int stock,
      double purchase,
      double sell,
      String cat,
      int threshold,
      List<String> images,
      int age,
      String? video) {
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      sku: sku,
      stock: stock,
      purchasePrice: purchase,
      sellingPrice: sell,
      category: cat,
      minStockThreshold: threshold,
      imageUrls: images,
      ageRating: age,
      videoUrl: video, description: '', price: 0, imageUrl: '',
    );
    _products.add(newProduct);
    notifyListeners();
  }

  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(Product product) {
    _products.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }

  void toggleSafeMode(bool isEnabled) {
    _isSafeModeEnabled = isEnabled;
    notifyListeners();
  }

  void updateSafeModeAgeLimit(int age) {
    _safeModeAgeLimit = age;
    notifyListeners();
  }

  void selectProductForLabel(Product product) {
    _selectedProductForLabel = product;
    notifyListeners();
  }

  String exportProductsToCsv() {
    // Logika untuk mengonversi _products ke string CSV
    // Contoh:
    // List<List<dynamic>> rows = [];
    // rows.add(['Nama', 'SKU', 'Stok', 'HargaBeli', 'HargaJual', 'Kategori', 'Threshold']);
    // for (var p in _products) {
    //   rows.add([p.name, p.sku, p.stock, p.purchasePrice, p.sellingPrice, p.category, p.minStockThreshold]);
    // }
    // return const ListToCsvConverter().convert(rows);
    logger.i("Exporting to CSV...");
    return "Nama,SKU,Stok,HargaBeli,HargaJual,Kategori,Threshold\nKopi,K-001,10,20000,25000,Minuman,5";
  }

  bool importProductsFromCsv(String csvData) {
    // Logika untuk mem-parsing string CSV dan menambahkan produk
    logger.i("Importing from CSV: $csvData");
    notifyListeners();
    return true;
  }

  Future<String> uploadImageToImgBB({required String imagePath}) async {
    // Logika untuk mengunggah gambar ke ImgBB atau layanan lain
    // Menggunakan package http
    logger.i("Uploading image from $imagePath...");
    await Future.delayed(const Duration(seconds: 2)); // Simulasi upload
    // URL gambar hasil upload palsu
    return 'https://i.ibb.co/3kC3NfV/product-coffee.jpg';
  }

  void triggerNotification(String title, String body) {
    // Logika untuk menampilkan notifikasi lokal
    // Menggunakan package flutter_local_notifications
    logger.i("NOTIFICATION: $title - $body");
  }
}
