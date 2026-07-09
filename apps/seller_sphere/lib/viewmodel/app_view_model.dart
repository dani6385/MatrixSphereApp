import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:seller_sphere/data/local/app_database.dart';
import 'package:seller_sphere/data/repository/app_repository.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';

// --- MODELS ---

class NotificationItem {
  final int id;
  final String title;
  final String message;
  final int timestamp;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
  });
}

final appViewModelProvider = ChangeNotifierProvider((ref) {
  final viewModel = AppViewModel();
  viewModel.initialize();
  return viewModel;
});

class AppViewModel extends ChangeNotifier {
  late AppRepository _repository;
  bool _isInitialized = false;

  Stream<List<Product>> products = const Stream.empty();
  Stream<List<Product>> lowStockProducts = const Stream.empty();
  Stream<List<SaleTransaction>> transactions = const Stream.empty();
  Stream<List<SaleItem>> allSaleItems = const Stream.empty();
  
  List<SaleTransaction> _latestTransactions = [];

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    final database = await getAppDatabase();
    _repository = AppRepository(
      productDao: database.productDao,
      transactionDao: database.transactionDao,
      targetDao: database.targetDao,
    );

    products = _repository.allProducts;
    lowStockProducts = _repository.lowStockProducts;
    transactions = _repository.allTransactions;
    allSaleItems = _repository.allSaleItems;
    
    transactions.listen((trans) {
      _latestTransactions = trans;
    });

    await _seedInitialData();
    _initShopsphereOrders();
    loadTodayTarget();

    _isInitialized = true;
    notifyListeners();
  }
  
  List<ShopsphereOrder> _shopsphereOrders = [];
  List<ShopsphereOrder> get shopsphereOrders => _shopsphereOrders;

  void _initShopsphereOrders() {
    final ordersList = <ShopsphereOrder>[];
    
    final productNames = ["Kemeja Flanel Slimfit", "Jeans Denim Premium", "Botol Minum Tumbler", "Sepatu Sneakers Klasik", "Kaos Polos Cotton 30s"];
    final customerNames = ["Budi Santoso", "Siti Rahma", "Dian Pratama", "Rian Wijaya", "Novianti", "Adi Hidayat", "Eka Putri", "Fajar Nugraha", "Gita Lestari", "Hendra Wijaya"];
    final courierNames = ["Ahmad (Express)", "Yanto (J&T)", "Budiman (Express)", "Agus (SiCepat)", "Husein (Express)", "Dedi (Anteraja)"];
    final random = Random();

    for (var day = 0; day <= 6; day++) {
      final orderCount = [4, 5, 3, 6, 4, 7, 5][day];

      for (var o = 0; o < orderCount; o++) {
        final orderId = "SS-${100000 + day * 1000 + o * 10}";
        final prodName = productNames[random.nextInt(productNames.length)];
        final qty = random.nextInt(3) + 1;
        final custName = customerNames[random.nextInt(customerNames.length)];
        final courName = courierNames[random.nextInt(courierNames.length)];
        final amount = qty * 50000.0;
        
        String status;
        if (day < 6) {
          status = "Selesai Dijemput";
        } else {
          status = ["Menunggu Kurir", "Kurir Menuju Lokasi", "Menunggu Kurir", "Selesai Dijemput", "Menunggu Kurir"][o % 5];
        }

        ordersList.add(ShopsphereOrder(
          id: orderId,
          dayIndex: day,
          productName: prodName,
          quantity: qty,
          customerName: custName,
          courierName: courName,
          totalAmount: amount,
          status: status,
        ));
      }
    }
    _shopsphereOrders = ordersList;
    notifyListeners();
  }

  void confirmOrderPickup(String orderId) {
    final index = _shopsphereOrders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      final order = _shopsphereOrders[index];
      _shopsphereOrders[index] = order.copyWith(status: "Selesai Dijemput");
      triggerNotification(
        "Penjemputan Berhasil 📦",
        "Pesanan ${order.id} (${order.productName}) telah dijemput oleh ${order.courierName}."
      );
      notifyListeners();
    }
  }

  void callCourier(String orderId) {
    final order = _shopsphereOrders.firstWhere((o) => o.id == orderId);
    triggerNotification(
      "Menghubungi Kurir 📞",
      "Menghubungi ${order.courierName} untuk penjemputan pesanan ${order.id}."
    );
  }

  Future<void> printOrderLabel(String orderId) async {
    final order = _shopsphereOrders.firstWhere((o) => o.id == orderId);
    triggerNotification(
      "Cetak Resi Sukses 🖨️",
      "Resi pengiriman untuk order ${order.id} berhasil dicetak menggunakan printer thermal."
    );
  }

  SalesTarget? _todayTarget;
  SalesTarget? get todayTarget => _todayTarget;
  
  String get _todayDateString => DateFormat("yyyy-MM-dd").format(DateTime.now());

  void loadTodayTarget() {
    _repository.getTargetForDate(_todayDateString).listen((target) {
      if (target == null) {
        _todayTarget = SalesTarget(dateString: _todayDateString, targetAmount: 1000000.0);
      } else {
        _todayTarget = target;
      }
      notifyListeners();
    });
  }

  Future<void> updateTodayTarget(double amount) async {
    final target = SalesTarget(dateString: _todayDateString, targetAmount: amount);
    await _repository.insertTarget(target);
    _todayTarget = target;
    triggerNotification("Target Penjualan Diperbarui", "Target hari ini diatur sebesar ${formatRupiah(amount)}");
    notifyListeners();
  }
  
  Map<Product, int> _cart = {};
  Map<Product, int> get cart => _cart;

  void addToCart(Product product) {
    if (product.stock <= 0) {
      triggerNotification("Stok Habis", "Produk ${product.name} tidak memiliki stok tersisa.");
      return;
    }
    final currentQty = _cart[product] ?? 0;
    if (currentQty + 1 > product.stock) {
      triggerNotification("Stok Tidak Cukup", "Hanya tersedia ${product.stock} unit untuk ${product.name}.");
      return;
    }
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

    double totalAmount = 0.0;
    double totalProfit = 0.0;
    
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
    
    final transId = await _repository.insertTransaction(transaction);

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
      await _repository.insertSaleItem(saleItem);
      
      final updatedStock = product.stock - qty;
      final updatedProduct = Product(
        id: product.id,
        name: product.name,
        sku: product.sku,
        stock: updatedStock.clamp(0, 99999).toInt(),
        purchasePrice: product.purchasePrice,
        sellingPrice: product.sellingPrice,
        category: product.category,
        minStockThreshold: product.minStockThreshold
      );
      await _repository.updateProduct(updatedProduct);
      
      if (updatedStock <= product.minStockThreshold) {
        triggerNotification(
          "Stok Menipis!",
          "Stok ${updatedProduct.name} tersisa $updatedStock unit (Batas: ${updatedProduct.minStockThreshold} unit)."
        );
      }
    }
    
    _checkTargetMilestoneAchievement(totalAmount);
    clearCart();
    triggerNotification("Penjualan Berhasil", "Transaksi #$transId selesai. Total: ${formatRupiah(totalAmount)}");
  }

  Future<void> _checkTargetMilestoneAchievement(double newSaleAmount) async {
      final target = _todayTarget?.targetAmount ?? 1000000.0;
      final previousSales = await getTodaySalesTotal();
      final todayTotalSales = previousSales + newSaleAmount;
      
      final prevPercentage = (previousSales / target) * 100;
      final newPercentage = (todayTotalSales / target) * 100;

      if (prevPercentage < 50 && newPercentage >= 50) {
        triggerNotification("Target Penjualan 50% Tercapai! 🎉", "Mantap! Anda sudah mencapai setengah target penjualan hari ini.");
      } else if (prevPercentage < 100 && newPercentage >= 100) {
        triggerNotification("Target Harian 100% Tercapai! 🏆🔥", "Luar biasa! Target penjualan harian sebesar ${formatRupiah(target)} telah terpenuhi!");
      }
  }

  Future<double> getTodaySalesTotal() async {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999).millisecondsSinceEpoch;

    final todayTrans = _latestTransactions.where((t) => t.timestamp >= startOfToday && t.timestamp <= endOfToday);
    return todayTrans.fold(0.0, (sum, item) => sum + item.totalAmount);
  }
    double getTodaySalesTotalSync() {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999).millisecondsSinceEpoch;

    final todayTrans = _latestTransactions.where((t) => t.timestamp >= startOfToday && t.timestamp <= endOfToday);
    return todayTrans.fold(0.0, (sum, item) => sum + item.totalAmount);
  }


  Future<void> addProduct({required String name, required String sku, required int stock, required double purchasePrice, required double sellingPrice, required String category, required int threshold}) async {
    final product = Product(name: name, sku: sku, stock: stock, purchasePrice: purchasePrice, sellingPrice: sellingPrice, category: category, minStockThreshold: threshold);
    await _repository.insertProduct(product);
    triggerNotification("Produk Ditambahkan", "Produk $name berhasil dimasukkan ke inventaris.");
  }
  
  Future<void> updateProduct(Product product) async {
    await _repository.updateProduct(product);
    triggerNotification("Produk Diperbarui", "Data ${product.name} telah disimpan.");
  }
  
  Future<void> deleteProduct(Product product) async {
    await _repository.deleteProduct(product);
    triggerNotification("Produk Dihapus", "Produk ${product.name} berhasil dihapus.");
  }

  Product? _selectedProductForLabel;
  Product? get selectedProductForLabel => _selectedProductForLabel;
  
  String _selectedTemplate = "Minimalis Modern";
  String get selectedTemplate => _selectedTemplate;

  String _customStoreName = "SS Seller Sphere";
  String get customStoreName => _customStoreName;
  
  int _promoDiscountPercent = 10;
  int get promoDiscountPercent => _promoDiscountPercent;

  String _labelSize = "50x30 mm";
  String get labelSize => _labelSize;
  
  void selectProductForLabel(Product product) {
    _selectedProductForLabel = product;
    notifyListeners();
  }
  
  void updateLabelTemplate(String templateName) {
    _selectedTemplate = templateName;
    notifyListeners();
  }
  
  void updateCustomStoreName(String name) {
    _customStoreName = name;
    notifyListeners();
  }
  
  void updatePromoDiscount(int percent) {
    _promoDiscountPercent = percent;
    notifyListeners();
  }
  
  void updateLabelSize(String size) {
    _labelSize = size;
    notifyListeners();
  }
  
  String _printerConnectionState = "Terputus";
  String get printerConnectionState => _printerConnectionState;
  
  List<String> _availablePrinters = [];
  List<String> get availablePrinters => _availablePrinters;
  
  bool _isPrinting = false;
  bool get isPrinting => _isPrinting;

  Future<void> startPrinterDiscovery() async {
    _printerConnectionState = "Mencari...";
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1500));
    _availablePrinters = ["PT-210 Thermal Printer", "RPP02N Mobile", "Zebra ZD410-Label", "Rongta RP326"];
    _printerConnectionState = "Pilih Printer";
    notifyListeners();
  }
  
  Future<void> connectToPrinter(String printerName) async {
    _printerConnectionState = "Menghubungkan...";
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1200));
    _printerConnectionState = "Terhubung ($printerName)";
    triggerNotification("Printer Terhubung", "Siap mencetak ke $printerName.");
    notifyListeners();
  }
  
  void disconnectPrinter() {
    _printerConnectionState = "Terputus";
    _availablePrinters = [];
    notifyListeners();
  }
  
  Future<void> simulatePrintLabel() async {
    if (_selectedProductForLabel == null) {
      triggerNotification("Gagal Mencetak", "Pilih produk terlebih dahulu!");
      return;
    }
    _isPrinting = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 2000));
    _isPrinting = false;
    triggerNotification("Cetak Selesai 🖨️", "Label untuk ${_selectedProductForLabel!.name} sukses dikirim ke printer.");
    notifyListeners();
  }

  String _syncCode = "SPHERE-SELLER-7F2A";
  String get syncCode => _syncCode;
  
  String _syncStatus = "Sinkronisasi Aktif (Otomatis)";
  String get syncStatus => _syncStatus;
  
  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;
  
  List<String> _syncLogs = [];
  List<String> get syncLogs => _syncLogs;

  void generateNewSyncCode() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    final random = Random();
    final code = "SPHERE-${String.fromCharCodes(Iterable.generate(4, (_) => chars.codeUnitAt(random.nextInt(chars.length))))}-${String.fromCharCodes(Iterable.generate(4, (_) => chars.codeUnitAt(random.nextInt(chars.length))))}";
    _syncCode = code;
    _addSyncLog("Kode sinkronisasi baru dihasilkan: $_syncCode");
    notifyListeners();
  }
  
  Future<void> triggerManualSync() async {
    _isSyncing = true;
    _syncStatus = "Menghubungkan ke Cloud...";
    _addSyncLog("Menghubungkan ke server Seller Sphere Cloud...");
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    
    _syncStatus = "Mengunduh Perubahan...";
    _addSyncLog("Membandingkan data lokal dengan cloud...");
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    
    final currentProducts = await products.first;
    if (currentProducts.length < 10) {
      final names = ["Kopi Robusta Premium", "Teh Hijau Organik", "Cokelat Susu 100g", "Minyak Goreng 1L", "Gula Pasir 1kg"];
      final categories = ["Minuman", "Minuman", "Makanan", "Bahan Pokok", "Bahan Pokok"];
      final randIndex = Random().nextInt(names.length);
      final newProd = Product(
        name: "${names[randIndex]} (Cloud)",
        sku: "SKU-CLOUD-${Random().nextInt(899) + 100}",
        stock: Random().nextInt(41) + 10,
        purchasePrice: 12000.0,
        sellingPrice: 16500.0,
        category: categories[randIndex],
        minStockThreshold: 5,
      );
      await _repository.insertProduct(newProd);
      _addSyncLog("Data produk baru disinkronkan: ${newProd.name}");
    }
    
    _isSyncing = false;
    _syncStatus = "Sinkronisasi Aktif (Otomatis)";
    _addSyncLog("Sinkronisasi real-time berhasil diselesaikan.");
    triggerNotification("Sinkronisasi Selesai", "Data inventaris dan penjualan berhasil disinkronkan.");
    notifyListeners();
  }
  
  void _addSyncLog(String message) {
    final time = DateFormat("HH:mm:ss").format(DateTime.now());
    _syncLogs.insert(0, "[$time] $message");
    if (_syncLogs.length > 100) {
      _syncLogs.removeLast();
    }
  }
  
  Future<String> exportProductsToCsv() async {
    final prods = await products.first;
    final sb = StringBuffer();
    sb.writeln("ID,Nama Produk,SKU,Stok,Harga Beli,Harga Jual,Kategori,Ambang Minimum");
    for (var p in prods) {
      final name = p.name.replaceAll('"', '""');
      final category = p.category.replaceAll('"', '""');
      sb.writeln('${p.id},"$name",${p.sku},${p.stock},${p.purchasePrice},${p.sellingPrice},"$category",${p.minStockThreshold}');
    }
    return sb.toString();
  }
  
  Future<String> exportTransactionsToCsv() async {
    final trans = await transactions.first;
    final sb = StringBuffer();
    sb.writeln("ID,Tanggal,Total Omzet,Total Keuntungan,Metode Pembayaran");
    for (var t in trans) {
      final dateStr = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.fromMillisecondsSinceEpoch(t.timestamp));
      sb.writeln("${t.id},${dateStr},${t.totalAmount},${t.totalProfit},${t.paymentMethod}");
    }
    return sb.toString();
  }

  Future<bool> importProductsFromCsv(String csvContent) async {
    try {
      final lines = csvContent.split('\n');
      if (lines.length <= 1) return false;

      for (var i = 1; i < lines.length; i++) {
        final line = lines[i];
        if (line.trim().isEmpty) continue;
        
        final tokens = _parseCsvLine(line);
        if (tokens.length >= 7) {
          final p = Product(
            name: tokens[1],
            sku: tokens[2],
            stock: int.tryParse(tokens[3]) ?? 0,
            purchasePrice: double.tryParse(tokens[4]) ?? 0.0,
            sellingPrice: double.tryParse(tokens[5]) ?? 0.0,
            category: tokens[6],
            minStockThreshold: (tokens.length > 7) ? (int.tryParse(tokens[7]) ?? 5) : 5,
          );
          await _repository.insertProduct(p);
        }
      }
      triggerNotification("Impor Sukses", "Data produk berhasil diimpor dari file CSV.");
      return true;
    } catch (e) {
      triggerNotification("Impor Gagal", "Terjadi kesalahan saat memproses file CSV.");
      return false;
    }
  }
  
  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;
    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i+1] == '"') {
          buffer.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == ',' && !inQuotes) {
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }
    result.add(buffer.toString());
    return result;
  }
  
  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;
  
  final _notificationController = StreamController<NotificationItem>.broadcast();
  Stream<NotificationItem> get notificationFlow => _notificationController.stream;

  void triggerNotification(String title, String message) {
    final newItem = NotificationItem(
      id: DateTime.now().microsecondsSinceEpoch,
      title: title,
      message: message,
      timestamp: DateTime.now().millisecondsSinceEpoch
    );
    _notifications.insert(0, newItem);
    if (_notifications.length > 50) {
      _notifications.removeLast();
    }
    _notificationController.add(newItem);
    notifyListeners();
  }
  
  Future<void> _seedInitialData() async {
    final prodCount = (await products.first).length;
    if (prodCount == 0) {
      final sampleProducts = [
        Product(name: "Kemeja Flanel Slimfit", sku: "BJU-01", stock: 3, purchasePrice: 85000.0, sellingPrice: 135000.0, category: "Pakaian", minStockThreshold: 4),
        Product(name: "Jeans Denim Premium", sku: "BJU-02", stock: 12, purchasePrice: 120000.0, sellingPrice: 199000.0, category: "Pakaian", minStockThreshold: 5),
        Product(name: "Botol Minum Tumbler", sku: "ACC-01", stock: 20, purchasePrice: 25000.0, sellingPrice: 45000.0, category: "Aksesoris", minStockThreshold: 6),
        Product(name: "Sepatu Sneakers Klasik", sku: "SPT-01", stock: 2, purchasePrice: 150000.0, sellingPrice: 250000.0, category: "Sepatu", minStockThreshold: 3),
        Product(name: "Kaos Polos Cotton 30s", sku: "BJU-03", stock: 45, purchasePrice: 18000.0, sellingPrice: 35000.0, category: "Pakaian", minStockThreshold: 8)
      ];
      for (var p in sampleProducts) { await _repository.insertProduct(p); }

      final randomSales = [450000.0, 680000.0, 540000.0, 920000.0, 1200000.0, 850000.0, 750000.0];
      final randomProfits = [170000.0, 240000.0, 210000.0, 360000.0, 480000.0, 310000.0, 290000.0];

      for (var i = 0; i <= 6; i++) {
        final date = DateTime.now().subtract(Duration(days: 6 - i));
        final dateStr = DateFormat("yyyy-MM-dd").format(date);
        
        await _repository.insertTarget(SalesTarget(dateString: dateStr, targetAmount: 1000000.0));
        
        final transaction = SaleTransaction(
          timestamp: date.millisecondsSinceEpoch,
          totalAmount: randomSales[i],
          totalProfit: randomProfits[i],
          paymentMethod: i % 2 == 0 ? "Tunai" : "QRIS"
        );
        await _repository.insertTransaction(transaction);
      }
    }
  }
  
  String formatRupiah(double amount) {
    final format = NumberFormat.currency(locale: 'in_ID', symbol: 'Rp ', decimalDigits: 0);
    return format.format(amount);
  }

  @override
  void dispose() {
    _notificationController.close();
    super.dispose();
  }
}
