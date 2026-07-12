import 'package:flutter/material.dart';

class AppViewModel extends ChangeNotifier {
  void updateTodayTarget(double newTarget) {
    // Implementasi logika untuk memperbarui target hari ini
    notifyListeners();
  }

  void finishPacking(String orderId) {
    // Implementasi logika untuk menyelesaikan pengepakan pesanan
    notifyListeners();
  }

  void callCourier(String orderId) {
    // Implementasi logika untuk memanggil kurir
    notifyListeners();
  }

  void printOrderLabel(String orderId) {
    // Implementasi logika untuk mencetak label pesanan
    notifyListeners();
  }

  void confirmOrderPickup(String orderId) {
    // Implementasi logika untuk mengkonfirmasi pengambilan pesanan
    notifyListeners();
  }
}
