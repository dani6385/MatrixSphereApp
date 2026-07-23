import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/models/product.dart';

import 'package:seller_sphere/services/product_service.dart';

import 'package:logger/logger.dart';

// Impor pustaka lain yang diperlukan untuk logika bisnis
// import 'package:csv/csv.dart';
// import 'package:http/http.dart' as http;
final Logger logger = Logger();

class AppProvider with ChangeNotifier {
  // --- Services ---
  final ProductService _productService = ProductService();
  late StreamSubscription<List<Product>> _productsSubscription;

  // --- State ---
  List<Product> _products = [];

  AppProvider() {
    _listenToProducts();
  }

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

  // --- Logika Bisnis dengan Firebase ---

  void _listenToProducts() {
    _productsSubscription =
        _productService.getProductsStream().listen((newProducts) {
      _products = newProducts;
      notifyListeners();
    }, onError: (error) => logger.e("Error listening to products: $error"));
  }

  /// Menambahkan produk baru dengan meneruskan objek [Product] yang sudah dibuat.
  /// Pembuatan objek Product sekarang ditangani oleh UI layer.
  Future<void> addProduct(Product newProduct) {
    return _productService.addProduct(newProduct);
  }

  Future<void> updateProduct(Product updatedProduct) {
    return _productService.updateProduct(updatedProduct);
  }

  Future<void> deleteProduct(Product product) {
    return _productService.deleteProduct(product.id);
  }

  @override
  void dispose() {
    _productsSubscription.cancel();
    super.dispose();
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

extension on Product {}
