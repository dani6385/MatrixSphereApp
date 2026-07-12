import 'dart:math';

import 'package:seller_sphere/data/dao.dart';
import 'package:seller_sphere/models/product.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/models/today_target.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class AppRepository {

  // The constructor accepts a database, but it will be ignored in this debug version.
  AppRepository({required AppDatabase database});

  // --- Mock Data ---
  final List<Product> _products = [
    Product(id: "P001", name: "Kopi robusta", stock: 5, price: 25000),
    Product(id: "P002", name: "Gula Pasir", stock: 10, price: 12000),
    Product(id: "P003", name: "Teh Celup", stock: 2, price: 8000),
  ];

  final List<ShopsphereOrder> _orders = List.generate(20, (index) {
    final random = Random();
    final day = random.nextInt(7);
    final statusOptions = ["Perlu Dipacking", "Siap Diambil", "Selesai Diambil"];
    final status = statusOptions[random.nextInt(3)];

    return ShopsphereOrder(
        id: "SS-100${index + 1}",
        dayIndex: day,
        productName: "Produk Acak ${index + 1}",
        quantity: random.nextInt(3) + 1,
        customerName: "Pelanggan ${index + 1}",
        courierPhone: "08123456789$index",
        totalAmount: (random.nextDouble() * 100000) + 20000,
        status: status,
        verificationCode: "123456");
  });

  TodayTarget _todayTarget = TodayTarget(targetAmount: 750000.0);

  // --- Mock API Methods ---

  Future<List<Product>> getLowStockProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _products.where((p) => p.stock < 10).toList();
  }

  Future<List<ShopsphereOrder>> getShopsphereOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _orders;
  }

  Future<TodayTarget> getTodayTarget() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _todayTarget;
  }

  Future<void> updateTodayTarget(double newAmount) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _todayTarget = TodayTarget(targetAmount: newAmount);
  }

  Future<void> finishPacking(String orderId) async {
    _updateOrderStatus(orderId, "Siap Diambil");
  }

  Future<void> confirmOrderPickup(String orderId) async {
    _updateOrderStatus(orderId, "Selesai Diambil");
  }

  void _updateOrderStatus(String orderId, String newStatus) {
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex != -1) {
      final oldOrder = _orders[orderIndex];
      _orders[orderIndex] = ShopsphereOrder(
        id: oldOrder.id,
        dayIndex: oldOrder.dayIndex,
        productName: oldOrder.productName,
        quantity: oldOrder.quantity,
        customerName: oldOrder.customerName,
        courierPhone: oldOrder.courierPhone,
        totalAmount: oldOrder.totalAmount,
        status: newStatus,
        verificationCode: oldOrder.verificationCode,
      );
    }
  }

  Future<void> callCourier(String orderId) async {
    logger.i("Calling courier for order $orderId...");
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> printOrderLabel(String orderId) async {
    logger.i("Printing label for order $orderId...");
    await Future.delayed(const Duration(seconds: 1));
  }
}
