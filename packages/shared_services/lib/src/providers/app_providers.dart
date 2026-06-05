import 'package:flutter/material.dart';

/// Provider untuk mengelola data real-time dari MikroTik/Firebase
class RealTime extends ChangeNotifier {
  // Contoh variabel data
  int _activeUsers = 0;
  double _cpuLoad = 0.0;
  bool _isLoading = false;

  // Getter
  int get activeUsers => _activeUsers;
  double get cpuLoad => _cpuLoad;
  bool get isLoading => _isLoading;

  /// Fungsi untuk mengupdate data (misalnya dipanggil oleh listener Firebase)
  void updateStats({required int users, required double cpu}) {
    _activeUsers = users;
    _cpuLoad = cpu;
    notifyListeners(); // Memberi tahu UI agar update tampilan
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
