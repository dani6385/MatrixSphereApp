import 'package:flutter/foundation.dart';

class RealTime extends ChangeNotifier {
  // Semua logika data real-time Anda di sini
  // ...
  void updateData() {
    notifyListeners();
  }
}
