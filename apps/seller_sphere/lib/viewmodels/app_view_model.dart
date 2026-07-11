import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:seller_sphere/data/repository.dart';
import 'package:seller_sphere/data/dao.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/utils/formatting.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

class AppViewModel extends ChangeNotifier {
  final AppRepository repository;

  AppViewModel(this.repository) {
    _init();
  }

  // --- State Properties ---
  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _lowStockProducts = [];
  List<Product> get lowStockProducts => _lowStockProducts;

  List<SaleTransaction> _transactions = [];
  List<SaleTransaction> get transactions => _transactions;

  List<SaleItem> _allSaleItems = [];
  List<SaleItem> get allSaleItems => _allSaleItems;

  SalesTarget? _todayTarget;
  SalesTarget? get todayTarget => _todayTarget;

  final Map<Product, int> _cart = {};
  Map<Product, int> get cart => _cart;

  List<ShopsphereOrder> _shopsphereOrders = [];
  List<ShopsphereOrder> get shopsphereOrders => _shopsphereOrders;

  List<BuyerChat> _buyerChats = [];
  List<BuyerChat> get buyerChats => _buyerChats;

  String? activeChatBuyerName;

  // --- Settings ---
  late SharedPreferences _prefs;

  bool _isDarkTheme = true;
  bool get isDarkTheme => _isDarkTheme;

  String _defaultPaymentMethod = "Tunai";
  String get defaultPaymentMethod => _defaultPaymentMethod;

  bool _isSafeModeEnabled = false;
  bool get isSafeModeEnabled => _isSafeModeEnabled;

  int _safeModeAgeLimit = 13;
  int get safeModeAgeLimit => _safeModeAgeLimit;

  // --- Firebase RTDB Config ---
  String _rtdbUrl =
      "https://matrixsphere-c3de9-default-rtdb.asia-southeast1.firebasedatabase.app";
  String get rtdbUrl => _rtdbUrl;

  String _customStoreName = "SS Seller Sphere";
  String get customStoreName => _customStoreName;

  String _ownerName = "Dani";
  String get ownerName => _ownerName;

  String _ownerEmail = "dani6385@gmail.com";
  String get ownerEmail => _ownerEmail;

  String _pickupAddress = "Jl. Kebon Jeruk No. 88, Jakarta Barat";
  String get pickupAddress => _pickupAddress;

  double _pickupLatitude = -6.1751;
  double get pickupLatitude => _pickupLatitude;

  double _pickupLongitude = 106.8272;
  double get pickupLongitude => _pickupLongitude;

  String _pickupNotes = "Pagar hitam, di depan minimarket";
  String get pickupNotes => _pickupNotes;

  final String _ownerWhatsapp = "081234567890";
  String get ownerWhatsapp => _ownerWhatsapp;

  final String _ownerSms = "081234567890";
  String get ownerSms => _ownerSms;

  final bool _isEmailNotificationEnabled = true;
  bool get isEmailNotificationEnabled => _isEmailNotificationEnabled;

  final bool _isWhatsappNotificationEnabled = true;
  bool get isWhatsappNotificationEnabled => _isWhatsappNotificationEnabled;

  final bool _isSmsNotificationEnabled = true;
  bool get isSmsNotificationEnabled => _isSmsNotificationEnabled;

  // --- Sync State ---

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  final List<String> _syncLogs = [];
  List<String> get syncLogs => _syncLogs;

  final String _syncStatus = "Terhubung (Otomatis)";
  String get syncStatus => _syncStatus;

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();

    // Load settings
    _isDarkTheme = _prefs.getBool('is_dark_theme') ?? true;
    _defaultPaymentMethod =
        _prefs.getString('default_payment_method') ?? 'Tunai';
    _isSafeModeEnabled = _prefs.getBool('is_safe_mode_enabled') ?? false;
    _safeModeAgeLimit = _prefs.getInt('safe_mode_age_limit') ?? 13;
    _rtdbUrl =
        _prefs.getString('firebase_rtdb_url') ??
        "https://matrixsphere-c3de9-default-rtdb.asia-southeast1.firebasedatabase.app";
    _customStoreName =
        _prefs.getString('custom_store_name') ?? 'SS Seller Sphere';
    _ownerName = _prefs.getString('owner_name') ?? 'Dani';
    _ownerEmail = _prefs.getString('owner_email') ?? 'dani6385@gmail.com';
    _pickupAddress =
        _prefs.getString('pickup_address') ??
        'Jl. Kebon Jeruk No. 88, Jakarta Barat';
    _pickupLatitude = _prefs.getDouble('pickup_latitude') ?? -6.1751;
    _pickupLongitude = _prefs.getDouble('pickup_longitude') ?? 106.8272;
    _pickupNotes =
        _prefs.getString('pickup_notes') ?? 'Pagar hitam, di depan minimarket';

    // Listen to data streams
    repository.getAllProducts().listen((data) {
      _products = data;
      notifyListeners();
    });
    repository.getLowStockProducts().listen((data) {
      _lowStockProducts = data;
      notifyListeners();
    });
    repository.getAllTransactions().listen((data) {
      _transactions = data;
      notifyListeners();
    });
    repository.getAllSaleItems().listen((data) {
      _allSaleItems = data;
      notifyListeners();
    });

    await seedInitialData();
    initShopsphereOrders();
    initBuyerChats();
    loadTodayTarget();
    notifyListeners();
  }

  void toggleDarkTheme() {
    _isDarkTheme = !_isDarkTheme;
    _prefs.setBool('is_dark_theme', _isDarkTheme);
    notifyListeners();
  }

  void updateDefaultPaymentMethod(String method) {
    _defaultPaymentMethod = method;
    _prefs.setString('default_payment_method', method);
    addSyncLog("Metode pembayaran default diubah ke: $method");
    notifyListeners();
  }

  void addSyncLog(String message) {
    final time = DateFormat("HH:mm:ss").format(DateTime.now());
    _syncLogs.insert(0, "[$time] $message");
    notifyListeners();
  }

  Future<void> seedInitialData() async {
    final productCount = (await repository.getAllProducts().first).length;
    if (productCount == 0) {
      final sampleProducts = [
        Product(
          name: "Kemeja Flanel Slimfit",
          sku: "BJU-01",
          stock: 3,
          purchasePrice: 85000.0,
          sellingPrice: 135000.0,
          category: "Pakaian",
          minStockThreshold: 4,
          ageRating: 13,
        ),
        Product(
          name: "Jeans Denim Premium",
          sku: "BJU-02",
          stock: 12,
          purchasePrice: 120000.0,
          sellingPrice: 199000.0,
          category: "Pakaian",
          minStockThreshold: 5,
          ageRating: 18,
        ),
        Product(
          name: "Botol Minum Tumbler",
          sku: "ACC-01",
          stock: 20,
          purchasePrice: 25000.0,
          sellingPrice: 45000.0,
          category: "Aksesoris",
          minStockThreshold: 6,
          ageRating: 0,
        ),
        Product(
          name: "Sepatu Sneakers Klasik",
          sku: "SPT-01",
          stock: 2,
          purchasePrice: 150000.0,
          sellingPrice: 250000.0,
          category: "Sepatu",
          minStockThreshold: 3,
          ageRating: 13,
        ),
        Product(
          name: "Kaos Polos Cotton 30s",
          sku: "BJU-03",
          stock: 45,
          purchasePrice: 18000.0,
          sellingPrice: 35000.0,
          category: "Pakaian",
          minStockThreshold: 8,
          ageRating: 0,
        ),
      ];
      for (var p in sampleProducts) {
        await repository.insertProduct(p);
      }
    }
  }

  void initShopsphereOrders() {
    _shopsphereOrders = List.generate(15, (i) {
      final status = i % 4 == 0
          ? "Perlu Dipacking"
          : (i % 4 == 1 ? "Siap Diambil" : "Selesai Diambil");
      return ShopsphereOrder(
        id: "SS-100${Random().nextInt(900)}",
        dayIndex: Random().nextInt(7),
        productName: [
          "Kemeja",
          "Celana",
          "Sepatu",
          "Topi",
        ][Random().nextInt(4)],
        quantity: Random().nextInt(3) + 1,
        customerName: ["Andi", "Budi", "Siti"][Random().nextInt(3)],
        courierPhone: "08123456789",
        totalAmount: (Random().nextInt(10) + 5) * 10000.0,
        status: status,
        verificationCode: (100000 + Random().nextInt(900000)).toString(),
      );
    });
  }

  void initBuyerChats() {
    final now = DateTime.now().millisecondsSinceEpoch;
    _buyerChats = [
      BuyerChat(
        customerName: "Andi",
        messages: [
          BuyerMessage(
            senderName: "Andi",
            text: "Halo, produk ready?",
            timestamp: now - 3600 * 1000,
            isFromBuyer: true,
          ),
        ],
        unreadCount: 1,
        lastMessageTimestamp: now - 3600 * 1000,
      ),
    ];
  }

  void loadTodayTarget() async {
    final dateString = DateFormat("yyyy-MM-dd").format(DateTime.now());
    repository.getTargetForDate(dateString).listen((target) {
      _todayTarget =
          target ??
          SalesTarget(
            date: dateString,
            targetAmount: 1000000.0,
            dateString: '',
          );
      notifyListeners();
    });
  }

  void addToCart(Product product) {
    if (product.stock <= 0) return;
    final currentQty = _cart[product] ?? 0;
    if (currentQty + 1 > product.stock) return;
    _cart[product] = currentQty + 1;
    notifyListeners();
  }

  void removeFromCart(Product product) {
    final currentQty = _cart[product] ?? 0;
    if (currentQty <= 1) {
      _cart.remove(product);
    } else {
      _cart[product] = currentQty - 1;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<void> checkout(String paymentMethod) async {
    if (_cart.isEmpty) return;

    double totalAmount = 0;
    double totalProfit = 0;
    _cart.forEach((product, qty) {
      totalAmount += product.sellingPrice * qty;
      totalProfit += product.profitPerUnit * qty;
    });

    final transaction = SaleTransaction(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      totalAmount: totalAmount,
      totalProfit: totalProfit,
      paymentMethod: paymentMethod,
    );
    final transId = await repository.insertTransaction(transaction);

    for (var entry in _cart.entries) {
      final product = entry.key;
      final qty = entry.value;
      final saleItem = SaleItem(
        transactionId: transId,
        productId: product.id!,
        productName: product.name,
        quantity: qty,
        purchasePrice: product.purchasePrice,
        sellingPrice: product.sellingPrice,
      );
      await repository.insertSaleItem(saleItem);

      final updatedProduct = Product(
        id: product.id,
        name: product.name,
        sku: product.sku,
        stock: (product.stock - qty).clamp(0, product.stock).toInt(),
        purchasePrice: product.purchasePrice,
        sellingPrice: product.sellingPrice,
        category: product.category,
        minStockThreshold: product.minStockThreshold,
        imageUrls: product.imageUrls,
        ageRating: product.ageRating,
      );
      await repository.updateProduct(updatedProduct);
    }

    clearCart();
  }

  Future<void> uploadImageToImgBB(
    File imageFile,
    Function(String) onSuccess,
    Function(String) onError,
  ) async {
    _isSyncing = true;
    notifyListeners();
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          "https://api.imgbb.com/1/upload?key=f601727fed32cf7a175833d01d8a10ff",
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
      final response = await request.send();

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final json = jsonDecode(respStr);
        final imgBbResponse = ImgBbResponse.fromJson(json);
        if (imgBbResponse.success && imgBbResponse.data?.url != null) {
          onSuccess(imgBbResponse.data!.url!);
        } else {
          onError("API response indicates failure.");
        }
      } else {
        onError("Upload failed with status: ${response.statusCode}");
      }
    } catch (e) {
      onError("An error occurred: $e");
    }
    _isSyncing = false;
    notifyListeners();
  }

  void updateTodayTarget(double amount) async {
    final dateString = DateFormat("yyyy-MM-dd").format(DateTime.now());
    _todayTarget = SalesTarget(
      date: dateString,
      targetAmount: amount,
      dateString: '',
    );
    addSyncLog("Target penjualan harian diperbarui: ${formatRupiah(amount)}");
    notifyListeners();
  }

  void finishPacking(String orderId) {
    final index = _shopsphereOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      var order = _shopsphereOrders[index];
      _shopsphereOrders[index] = ShopsphereOrder(
        id: order.id,
        dayIndex: order.dayIndex,
        productName: order.productName,
        quantity: order.quantity,
        customerName: order.customerName,
        courierPhone: order.courierPhone,
        totalAmount: order.totalAmount,
        status: "Siap Diambil",
        verificationCode: order.verificationCode,
      );
      addSyncLog("Pesanan $orderId selesai dipacking.");
      notifyListeners();
    }
  }

  void callCourier(String orderId) {
    addSyncLog("Menghubungi pembeli untuk pesanan $orderId...");
    logger.i("Calling courier for order $orderId");
  }

  void printOrderLabel(String orderId) {
    addSyncLog("Mencetak nota untuk pesanan $orderId...");
    logger.i("Printing label for order $orderId");
  }

  void confirmOrderPickup(String orderId) {
    final index = _shopsphereOrders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      var order = _shopsphereOrders[index];
      _shopsphereOrders[index] = ShopsphereOrder(
        id: order.id,
        dayIndex: order.dayIndex,
        productName: order.productName,
        quantity: order.quantity,
        customerName: order.customerName,
        courierPhone: order.courierPhone,
        totalAmount: order.totalAmount,
        status: "Selesai Diambil",
        verificationCode: order.verificationCode,
      );
      addSyncLog("Pesanan $orderId telah dikonfirmasi diambil oleh pembeli.");
      notifyListeners();
    }
  }

  double getTodaySalesTotal() {
    if (_transactions.isEmpty) {
      return 0.0;
    }
    final todayStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ).millisecondsSinceEpoch;
    final todaysTransactions = _transactions.where(
      (t) => t.timestamp >= todayStart,
    );
    if (todaysTransactions.isEmpty) {
      return 0.0;
    }
    return todaysTransactions.map((t) => t.totalAmount).reduce((a, b) => a + b);
  }
}

class ImgBbResponse {
  final ImgBbData? data;
  final bool success;
  final int status;

  ImgBbResponse({this.data, required this.success, required this.status});

  factory ImgBbResponse.fromJson(Map<String, dynamic> json) {
    return ImgBbResponse(
      data: json['data'] != null ? ImgBbData.fromJson(json['data']) : null,
      success: json['success'],
      status: json['status'],
    );
  }
}

class ImgBbData {
  final String? url;
  final String? displayUrl;

  ImgBbData({this.url, this.displayUrl});

  factory ImgBbData.fromJson(Map<String, dynamic> json) {
    return ImgBbData(url: json['url'], displayUrl: json['display_url']);
  }
}

class BuyerMessage {
  final String id;
  final String senderName;
  final String text;
  final int timestamp;
  final bool isFromBuyer;

  BuyerMessage({
    String? id,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isFromBuyer,
  }) : id = id ?? Uuid().v4();
}

class BuyerChat {
  final String customerName;
  final List<BuyerMessage> messages;
  final int unreadCount;
  final int lastMessageTimestamp;

  BuyerChat({
    required this.customerName,
    required this.messages,
    required this.unreadCount,
    required this.lastMessageTimestamp,
  });
}

class Uuid {
  final Random _random = Random();
  String v4() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replaceAllMapped(
      RegExp(r'[xy]'),
      (match) {
        final int r = (_random.nextDouble() * 16).floor();
        final int v = match.group(0) == 'x' ? r : (r & 0x3 | 0x8);
        return v.toRadixString(16);
      },
    );
  }
}
