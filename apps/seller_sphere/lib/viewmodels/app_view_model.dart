
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

// --- DATA MODELS ---

class Product {
  final int id;
  final String name;
  final String sku;
  final int stock;
  final double purchasePrice;
  final double sellingPrice;
  final String category;
  final int minStockThreshold;
  final String imageUrls;

  bool get isLowStock => stock < minStockThreshold;

  Product({
    this.id = 0,
    required this.name,
    this.sku = '',
    required this.stock,
    required this.purchasePrice,
    required this.sellingPrice,
    this.category = 'Uncategorized',
    required this.minStockThreshold,
    this.imageUrls = '',
  });

  Product copyWith({
    int? id,
    String? name,
    String? sku,
    int? stock,
    double? purchasePrice,
    double? sellingPrice,
    String? category,
    int? minStockThreshold,
    String? imageUrls,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      stock: stock ?? this.stock,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      category: category ?? this.category,
      minStockThreshold: minStockThreshold ?? this.minStockThreshold,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'sku': sku,
        'stock': stock,
        'purchasePrice': purchasePrice,
        'sellingPrice': sellingPrice,
        'category': category,
        'minStockThreshold': minStockThreshold,
        'imageUrls': imageUrls,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] ?? 0,
        name: json['name'],
        sku: json['sku'] ?? '',
        stock: json['stock'],
        purchasePrice: (json['purchasePrice'] as num).toDouble(),
        sellingPrice: (json['sellingPrice'] as num).toDouble(),
        category: json['category'] ?? 'Uncategorized',
        minStockThreshold: json['minStockThreshold'],
        imageUrls: json['imageUrls'] ?? '',
      );
}

class SaleTransaction {
  final int id;
  final int timestamp;
  final double totalAmount;
  final double totalProfit;
  final String paymentMethod;

  SaleTransaction({
    this.id = 0,
    required this.timestamp,
    required this.totalAmount,
    required this.totalProfit,
    required this.paymentMethod,
  });

   Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp,
        'totalAmount': totalAmount,
        'totalProfit': totalProfit,
        'paymentMethod': paymentMethod,
      };

  factory SaleTransaction.fromJson(Map<String, dynamic> json) => SaleTransaction(
        id: json['id'] ?? 0,
        timestamp: json['timestamp'],
        totalAmount: (json['totalAmount'] as num).toDouble(),
        totalProfit: (json['totalProfit'] as num).toDouble(),
        paymentMethod: json['paymentMethod'],
      );
}

class SaleItem {
    final int id;
    final int transactionId;
    final int productId;
    final String productName;
    final int quantity;
    final double purchasePrice;
    final double sellingPrice;

    SaleItem({
        this.id = 0,
        required this.transactionId,
        required this.productId,
        required this.productName,
        required this.quantity,
        required this.purchasePrice,
        required this.sellingPrice,
    });
}

class SalesTarget {
  final String date; // YYYY-MM-DD
  final double targetAmount;

  SalesTarget(this.date, this.targetAmount);

   Map<String, dynamic> toJson() => {
        'date': date,
        'targetAmount': targetAmount,
      };

  factory SalesTarget.fromJson(Map<String, dynamic> json) => SalesTarget(
        json['date'],
        (json['targetAmount'] as num).toDouble(),
      );
}

class ShopsphereOrder {
  final String id;
  final String dateString;
  final int dayIndex;
  final String productName;
  final int quantity;
  final String customerName;
  final String courierName;
  final String courierPhone;
  final double totalAmount;
  final String status;
  final String verificationCode;

  ShopsphereOrder({
    required this.id,
    required this.dateString,
    required this.dayIndex,
    required this.productName,
    required this.quantity,
    required this.customerName,
    required this.courierName,
    required this.courierPhone,
    required this.totalAmount,
    required this.status,
    required this.verificationCode,
  });

   ShopsphereOrder copyWith({String? status}) {
    return ShopsphereOrder(
      id: id,
      dateString: dateString,
      dayIndex: dayIndex,
      productName: productName,
      quantity: quantity,
      customerName: customerName,
      courierName: courierName,
      courierPhone: courierPhone,
      totalAmount: totalAmount,
      status: status ?? this.status,
      verificationCode: verificationCode,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dateString': dateString,
    'dayIndex': dayIndex,
    'productName': productName,
    'quantity': quantity,
    'customerName': customerName,
    'courierName': courierName,
    'courierPhone': courierPhone,
    'totalAmount': totalAmount,
    'status': status,
    'verificationCode': verificationCode,
  };

  factory ShopsphereOrder.fromJson(Map<String, dynamic> json) => ShopsphereOrder(
    id: json['id'],
    dateString: json['dateString'],
    dayIndex: json['dayIndex'],
    productName: json['productName'],
    quantity: json['quantity'],
    customerName: json['customerName'],
    courierName: json['courierName'],
    courierPhone: json['courierPhone'],
    totalAmount: (json['totalAmount'] as num).toDouble(),
    status: json['status'],
    verificationCode: json['verificationCode'],
  );
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
        int? timestamp,
        required this.isFromBuyer,
    }) : this.id = id ?? UniqueKey().toString(),
         this.timestamp = timestamp ?? DateTime.now().millisecondsSinceEpoch;
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

    BuyerChat copyWith({
        List<BuyerMessage>? messages,
        int? unreadCount,
        int? lastMessageTimestamp,
    }) {
        return BuyerChat(
            customerName: customerName,
            messages: messages ?? this.messages,
            unreadCount: unreadCount ?? this.unreadCount,
            lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
        );
    }
}

class NotificationItem {
  final int id;
  final String title;
  final String message;
  final int timestamp;
  NotificationItem({required this.id, required this.title, required this.message, required this.timestamp});
}


// --- AppViewModel ---

class AppViewModel extends ChangeNotifier {
  // In-memory data stores, acting as a repository
  List<Product> _products = [];
  List<SaleTransaction> _transactions = [];
  List<SalesTarget> _targets = [];
  List<SaleItem> _saleItems = [];

  // Public getters for state observation
  List<Product> get products => _products;
  List<Product> get lowStockProducts => _products.where((p) => p.isLowStock).toList();
  List<SaleTransaction> get transactions => _transactions;

  List<ShopsphereOrder> _shopsphereOrders = [];
  List<ShopsphereOrder> get shopsphereOrders => _shopsphereOrders;

  List<BuyerChat> _buyerChats = [];
  List<BuyerChat> get buyerChats => _buyerChats;

  String? _activeChatBuyerName;
  String? get activeChatBuyerName => _activeChatBuyerName;
  set activeChatBuyerName(String? value) {
    _activeChatBuyerName = value;
    notifyListeners();
  }
  
  SalesTarget? _todayTarget;
  SalesTarget? get todayTarget => _todayTarget;

  bool _isDarkTheme = true;
  bool get isDarkTheme => _isDarkTheme;

  String _defaultPaymentMethod = "Tunai";
  String get defaultPaymentMethod => _defaultPaymentMethod;
  
  String _rtdbUrl = "https://matrixsphere-c3de9-default-rtdb.asia-southeast1.firebasedatabase.app";
  String get rtdbUrl => _rtdbUrl;
  
  String _customStoreName = "SS Seller Sphere";
  String get customStoreName => _customStoreName;

  String get sellerSphereNode => _getSanitizedStoreName();
  String get shopSphereNode => _getSanitizedStoreName();

  Map<Product, int> _cart = {};
  Map<Product, int> get cart => _cart;

  final StreamController<NotificationItem> _notificationController = StreamController.broadcast();
  Stream<NotificationItem> get notificationFlow => _notificationController.stream;

  AppViewModel() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadPrefs();
    _seedInitialData();
    _initShopsphereOrders();
    _initBuyerChats();
    loadTodayTarget();
    notifyListeners();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool("is_dark_theme") ?? true;
    _defaultPaymentMethod = prefs.getString("default_payment_method") ?? "Tunai";
    _rtdbUrl = prefs.getString("firebase_rtdb_url") ?? "https://matrixsphere-c3de9-default-rtdb.asia-southeast1.firebasedatabase.app";
    _customStoreName = prefs.getString("custom_store_name") ?? "SS Seller Sphere";
  }

  String _getSanitizedStoreName() {
    return _customStoreName.trim().toLowerCase()
        .replaceAll(RegExp(r"[^a-z0-9_-]"), "-")
        .replaceAll(RegExp(r"-+"), "-")
        .replaceAll(RegExp(r"^-|-$"), "")
        .isEmpty ? "unknown-store" : _customStoreName;
  }

  void toggleDarkTheme() async {
    _isDarkTheme = !_isDarkTheme;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_dark_theme", _isDarkTheme);
    notifyListeners();
  }
  
  void updateDefaultPaymentMethod(String method) async {
    _defaultPaymentMethod = method;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("default_payment_method", method);
    notifyListeners();
  }
  
  // --- POS and Cart Logic ---
  void addToCart(Product product) {
    if (product.stock <= (_cart[product] ?? 0)) {
        triggerNotification("Stok Tidak Cukup", "Stok ${product.name} hanya tersisa ${product.stock} unit.");
        return;
    }
    _cart[product] = (_cart[product] ?? 0) + 1;
    notifyListeners();
  }

  void removeFromCart(Product product) {
    if ((_cart[product] ?? 0) > 1) {
        _cart[product] = _cart[product]! - 1;
    } else {
        _cart.remove(product);
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
        totalProfit += (product.sellingPrice - product.purchasePrice) * qty;
    });

    final transaction = SaleTransaction(
        timestamp: DateTime.now().millisecondsSinceEpoch,
        totalAmount: totalAmount,
        totalProfit: totalProfit,
        paymentMethod: paymentMethod,
    );
    // In a real app, this would return the ID from the database
    final newTransactionId = (_transactions.isNotEmpty ? _transactions.map((t) => t.id).reduce(max) : 0) + 1;
    _transactions.add(SaleTransaction(id: newTransactionId, timestamp: transaction.timestamp, totalAmount: transaction.totalAmount, totalProfit: transaction.totalProfit, paymentMethod: transaction.paymentMethod));


    _cart.forEach((product, qty) {
        final saleItem = SaleItem(transactionId: newTransactionId, productId: product.id, productName: product.name, quantity: qty, purchasePrice: product.purchasePrice, sellingPrice: product.sellingPrice);
        _saleItems.add(saleItem);

        final productIndex = _products.indexWhere((p) => p.id == product.id);
        if(productIndex != -1) {
            final oldProduct = _products[productIndex];
            final updatedProduct = oldProduct.copyWith(stock: (oldProduct.stock - qty).clamp(0, 9999).toInt());
            _products[productIndex] = updatedProduct;

            if (updatedProduct.isLowStock) {
                triggerNotification(
                    "Stok Menipis!",
                    "Stok ${updatedProduct.name} tersisa ${updatedProduct.stock} unit (Batas minimum: ${updatedProduct.minStockThreshold} unit)."
                );
            }
        }
    });

    clearCart();
    // In a real app, you might await this
    pushDataToRtdb();
    triggerNotification("Penjualan Berhasil", "Transaksi #$newTransactionId selesai. Total: ${formatRupiah(totalAmount)}");
    notifyListeners();
  }

  // --- Product Management ---

  void addProduct({required String name, required int stock, required double purchasePrice, required double sellingPrice, required int minStockThreshold}) {
    final newProduct = Product(
      id: (_products.isNotEmpty ? _products.map((p) => p.id).reduce(max) : 0) + 1,
      name: name,
      stock: stock,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
      minStockThreshold: minStockThreshold
    );
    _products.add(newProduct);
    pushDataToRtdb();
    triggerNotification("Produk Ditambahkan", "Produk $name berhasil dimasukkan ke inventaris.");
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      pushDataToRtdb();
      triggerNotification("Produk Diperbarui", "Data ${product.name} telah disimpan.");
      notifyListeners();
    }
  }

  void deleteProduct(Product product) {
    _products.removeWhere((p) => p.id == product.id);
    pushDataToRtdb();
    triggerNotification("Produk Dihapus", "Produk ${product.name} berhasil dihapus.");
    notifyListeners();
  }

  // --- Target Management ---

  void loadTodayTarget() {
    final todayStr = DateFormat("yyyy-MM-dd").format(DateTime.now());
    final target = _targets.firstWhere((t) => t.date == todayStr, orElse: () => SalesTarget(todayStr, 1000000.0));
    _todayTarget = target;
    notifyListeners();
  }
  
  void updateTodayTarget(double amount) {
      final todayStr = DateFormat("yyyy-MM-dd").format(DateTime.now());
      final index = _targets.indexWhere((t) => t.date == todayStr);
      final newTarget = SalesTarget(todayStr, amount);
      if (index != -1) {
          _targets[index] = newTarget;
      } else {
          _targets.add(newTarget);
      }
      _todayTarget = newTarget;
      triggerNotification("Target Diperbarui", "Target penjualan hari ini: ${formatRupiah(amount)}");
      notifyListeners();
  }

  // --- RTDB Sync ---
  Future<void> pushDataToRtdb() async {
    final baseNodeUrl = "$_rtdbUrl/seller-sphere/${sellerSphereNode}";

    final productListJson = json.encode(_products.map((p) => p.toJson()).toList());
    final transactionListJson = json.encode(_transactions.map((t) => t.toJson()).toList());
    final targetListJson = json.encode(_targets.map((t) => t.toJson()).toList());

    try {
        await _uploadJsonNode("$baseNodeUrl/products.json", productListJson);
        await _uploadJsonNode("$baseNodeUrl/transactions.json", transactionListJson);
        await _uploadJsonNode("$baseNodeUrl/targets.json", targetListJson);
        triggerNotification("Sinkronisasi Sukses", "Data lokal berhasil diunggah ke cloud.");
    } catch (e) {
        triggerNotification("Sinkronisasi Gagal", "Gagal mengunggah data: $e");
    }
  }

  Future<void> _uploadJsonNode(String url, String json) async {
    final uri = Uri.parse(url);
    final response = await http.put(uri, body: json, headers: {'Content-Type': 'application/json'});
    if (response.statusCode >= 300) {
        throw Exception("Failed to write to $url. Code: ${response.statusCode}");
    }
  }

  // --- Shopsphere & Chat Logic ---
  
  void finishPacking(String orderId) {
    final index = _shopsphereOrders.indexWhere((o) => o.id == orderId);
    if(index != -1) {
        _shopsphereOrders[index] = _shopsphereOrders[index].copyWith(status: "Siap Diambil");
        triggerNotification("Packing Selesai 📦", "Pesanan $orderId siap diambil.");
        notifyListeners();
    }
  }

  void confirmOrderPickup(String orderId) {
      final index = _shopsphereOrders.indexWhere((o) => o.id == orderId);
      if(index != -1) {
        _shopsphereOrders[index] = _shopsphereOrders[index].copyWith(status: "Selesai Diambil");
        triggerNotification("Pengambilan Sukses", "Pesanan $orderId telah diambil.");
        notifyListeners();
      }
  }

  void markChatAsRead(String customerName) {
      final index = _buyerChats.indexWhere((c) => c.customerName == customerName);
      if (index != -1) {
          _buyerChats[index] = _buyerChats[index].copyWith(unreadCount: 0);
          notifyListeners();
      }
  }

  void sendMessageToBuyer(String customerName, String text) {
      final index = _buyerChats.indexWhere((c) => c.customerName == customerName);
      if (index != -1) {
          final newMsg = BuyerMessage(senderName: "Seller", text: text, isFromBuyer: false);
          final updatedMessages = List<BuyerMessage>.from(_buyerChats[index].messages)..add(newMsg);
          _buyerChats[index] = _buyerChats[index].copyWith(
              messages: updatedMessages,
              lastMessageTimestamp: newMsg.timestamp,
          );
          _simulateBuyerReply(customerName);
          notifyListeners();
      }
  }

  void _simulateBuyerReply(String customerName) async {
      await Future.delayed(const Duration(seconds: 2));
      final replies = [
          "Baik kak, terima kasih banyak atas responnya! 😊",
          "Siap kak, terima kasih infonya ya.",
          "Ok min, nanti kalau senggang saya mampir.",
          "Mantap! Terima kasih respon cepatnya min.",
          "Ditunggu ya kak kabarnya."
      ];
      final replyText = replies[Random().nextInt(replies.length)];
      final replyMsg = BuyerMessage(senderName: customerName, text: replyText, isFromBuyer: true);
      
      final index = _buyerChats.indexWhere((c) => c.customerName == customerName);
      if (index != -1) {
          final chat = _buyerChats[index];
          final updatedMessages = List<BuyerMessage>.from(chat.messages)..add(replyMsg);
          final bool isChatActive = activeChatBuyerName == customerName;
          _buyerChats[index] = chat.copyWith(
              messages: updatedMessages,
              lastMessageTimestamp: replyMsg.timestamp,
              unreadCount: isChatActive ? 0 : chat.unreadCount + 1,
          );
          if (!isChatActive) {
            triggerNotification("Pesan Baru: $customerName", replyText);
          }
          notifyListeners();
      }
  }


  // --- Helper & Utility Methods ---

  void triggerNotification(String title, String message) {
    final newItem = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      message: message,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    _notificationController.add(newItem);
  }

  String formatRupiah(double amount) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }
  
  double getTodaySalesTotal() {
    final todayStart = DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
    return transactions
        .where((t) => DateTime.fromMillisecondsSinceEpoch(t.timestamp).isAfter(todayStart))
        .fold(0.0, (sum, t) => sum + t.totalAmount);
  }

  void _seedInitialData() {
    if (_products.isNotEmpty) return;
    
    _products = [
      Product(id: 1, name: "Kemeja Flanel Slimfit", sku: "BJU-01", stock: 3, purchasePrice: 85000.0, sellingPrice: 135000.0, category: "Pakaian", minStockThreshold: 4),
      Product(id: 2, name: "Jeans Denim Premium", sku: "BJU-02", stock: 12, purchasePrice: 120000.0, sellingPrice: 199000.0, category: "Pakaian", minStockThreshold: 5),
      Product(id: 3, name: "Botol Minum Tumbler", sku: "ACC-01", stock: 20, purchasePrice: 25000.0, sellingPrice: 45000.0, category: "Aksesoris", minStockThreshold: 6),
      Product(id: 4, name: "Sepatu Sneakers Klasik", sku: "SPT-01", stock: 2, purchasePrice: 150000.0, sellingPrice: 250000.0, category: "Sepatu", minStockThreshold: 3),
      Product(id: 5, name: "Kaos Polos Cotton 30s", sku: "BJU-03", stock: 45, purchasePrice: 18000.0, sellingPrice: 35000.0, category: "Pakaian", minStockThreshold: 8)
    ];

    final now = DateTime.now();
    _transactions = [
        SaleTransaction(id: 1, timestamp: now.subtract(const Duration(days: 6)).millisecondsSinceEpoch, totalAmount: 450000, totalProfit: 170000, paymentMethod: "Tunai"),
        SaleTransaction(id: 2, timestamp: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch, totalAmount: 850000, totalProfit: 310000, paymentMethod: "QRIS"),
        SaleTransaction(id: 3, timestamp: now.millisecondsSinceEpoch, totalAmount: 750000, totalProfit: 290000, paymentMethod: "Tunai"),
    ];

  }
  
  void _initShopsphereOrders() {
    _shopsphereOrders = [
        ShopsphereOrder(id: 'SS-76251', dateString: '24/05', dayIndex: 6, productName: 'Kopi Susu', quantity: 2, customerName: 'Budi Hartono', courierName: 'Ahmad (Shopsphere Express)', courierPhone: '081234567890', totalAmount: 30000, status: 'Siap Diambil', verificationCode: '123456'),
        ShopsphereOrder(id: 'SS-76252', dateString: '24/05', dayIndex: 6, productName: 'Teh Manis', quantity: 1, customerName: 'Citra Lestari', courierName: 'Yanto (J&T Express)', courierPhone: '081234567891', totalAmount: 10000, status: 'Perlu Dipacking', verificationCode: '789012'),
        ShopsphereOrder(id: 'SS-76253', dateString: '23/05', dayIndex: 5, productName: 'Nasi Goreng', quantity: 1, customerName: 'Doni Firmansyah', courierName: 'Budiman (Shopsphere Express)', courierPhone: '081234567892', totalAmount: 25000, status: 'Selesai Diambil', verificationCode: '345678'),
    ];
  }
  
  void _initBuyerChats() {
    final now = DateTime.now().millisecondsSinceEpoch;
    _buyerChats = [
        BuyerChat(
            customerName: "Andi",
            messages: [
                BuyerMessage(senderName: "Andi", text: "Halo min, kemeja flanel slimfit size L ready?", timestamp: now - 3 * 3600 * 1000, isFromBuyer: true),
                BuyerMessage(senderName: "Seller", text: "Halo kak, ready ya. Silakan diorder.", timestamp: now - 2 * 3600 * 1000, isFromBuyer: false),
                BuyerMessage(senderName: "Andi", text: "Apakah barangnya sudah dikirim kak?", timestamp: now - 45 * 60 * 1000, isFromBuyer: true),
                BuyerMessage(senderName: "Andi", text: "Soalnya saya butuh cepat untuk acara besok.", timestamp: now - 44 * 60 * 1000, isFromBuyer: true)
            ],
            unreadCount: 2,
            lastMessageTimestamp: now - 44 * 60 * 1000
        ),
        BuyerChat(
            customerName: "Dewi",
            messages: [
                BuyerMessage(senderName: "Dewi", text: "Kak, botol minum tumbler saya bocor dikit. Apakah bisa ditukar?", timestamp: now - 15 * 60 * 1000, isFromBuyer: true)
            ],
            unreadCount: 1,
            lastMessageTimestamp: now - 15 * 60 * 1000
        ),
    ];
  }

  @override
  void dispose() {
    _notificationController.close();
    super.dispose();
  }
}
