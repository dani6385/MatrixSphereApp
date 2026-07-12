import 'package:flutter/material.dart';
import 'package:seller_sphere/data/app_repository.dart';
import 'package:seller_sphere/data/repository.dart';
import 'package:seller_sphere/models/product.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/models/today_target.dart';

class AppViewModel extends ChangeNotifier {
  final DebugRepository _repository = DebugRepository();

  bool _isDebugMode = true;
  bool get isDebugMode => _isDebugMode;

  List<Product> _lowStockProducts = [];
  List<Product> get lowStockProducts => _lowStockProducts;

  List<ShopsphereOrder> _shopsphereOrders = [];
  List<ShopsphereOrder> get shopsphereOrders => _shopsphereOrders;

  TodayTarget? _todayTarget;
  TodayTarget? get todayTarget => _todayTarget;

  String _activeChatBuyerName = "";
  String get activeChatBuyerName => _activeChatBuyerName;

  set activeChatBuyerName(String name) {
    _activeChatBuyerName = name;
    notifyListeners();
  }

  AppViewModel({required AppRepository repository}) {
    _loadInitialData();
  }

  void _loadInitialData() async {
    _lowStockProducts = await _repository.getLowStockProducts();
    _shopsphereOrders = await _repository.getShopsphereOrders();
    _todayTarget = await _repository.getTodayTarget();
    notifyListeners();
  }

  void toggleDebugMode() {
    _isDebugMode = !_isDebugMode;
    notifyListeners();
  }

  double getTodaySalesTotal() {
    return _shopsphereOrders
        .where((order) =>
            order.dayIndex == 6) // Assuming dayIndex 6 is today
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  void updateTodayTarget(double amount) async {
    await _repository.updateTodayTarget(amount);
    _todayTarget = await _repository.getTodayTarget();
    notifyListeners();
  }

  void finishPacking(String orderId) async {
    await _repository.finishPacking(orderId);
    _shopsphereOrders = await _repository.getShopsphereOrders();
    notifyListeners();
  }

  void confirmOrderPickup(String orderId) async {
    await _repository.confirmOrderPickup(orderId);
    _shopsphereOrders = await _repository.getShopsphereOrders();
    notifyListeners();
  }

  void callCourier(String orderId) {
    _repository.callCourier(orderId);
  }

  void printOrderLabel(String orderId) {
    _repository.printOrderLabel(orderId);
  }
}
