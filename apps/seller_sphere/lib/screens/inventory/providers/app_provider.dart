import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';


import 'package:seller_sphere/services/product_service.dart';

import 'package:logger/logger.dart';
import 'package:shared_services/shared_services.dart';

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
    const String apiKey = 'f601727fed32cf7a175833d01d8a10ff';
    final url = Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey');

    // 1. Baca gambar dari file
    final imageFile = File(imagePath);
    if (!await imageFile.exists()) {
      logger.e('File gambar tidak ditemukan di: $imagePath');
      throw Exception('File gambar tidak ditemukan.');
    }

    // 2. Kompres gambar
    final image = img.decodeImage(await imageFile.readAsBytes());
    if (image == null) {
      logger.e('Gagal mendekode gambar.');
      throw Exception('Gagal memproses gambar.');
    }

    // Atur kualitas kompresi (0-100)
    final compressedImage = img.encodeJpg(image, quality: 85);

    // 3. Buat request multipart
    final request = http.MultipartRequest('POST', url);
    final multipartFile = http.MultipartFile.fromBytes(
      'image',
      compressedImage,
      filename: 'compressed_image.jpg', // Nama file bisa disesuaikan
    );
    request.files.add(multipartFile);

    try {
      // 4. Kirim request dan dapatkan respons
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseBody);
        final imageUrl = decodedResponse['data']?['url'];

        if (imageUrl != null) {
          logger.i('Gambar berhasil diunggah: $imageUrl');
          return imageUrl;
        } else {
          logger.e('URL gambar tidak ditemukan di respons ImgBB.');
          throw Exception('Gagal mengurai respons dari ImgBB.');
        }
      } else {
        logger.e('Gagal mengunggah gambar. Status code: ${response.statusCode}');
        final errorBody = await response.stream.bytesToString();
        logger.e('Error response: $errorBody');
        throw Exception(
            'Gagal mengunggah gambar. Silakan coba lagi nanti.');
      }
    } catch (e) {
      logger.e('Terjadi kesalahan saat mengunggah gambar: $e');
      throw Exception('Terjadi kesalahan. Periksa koneksi internet Anda.');
    }
  }

  void triggerNotification(String title, String body) {
    // Logika untuk menampilkan notifikasi lokal
    // Menggunakan package flutter_local_notifications
    logger.i("NOTIFICATION: $title - $body");
  }
}

extension on Product {}
