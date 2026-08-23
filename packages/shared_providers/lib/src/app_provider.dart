import 'package:flutter/material.dart';

/// Provider untuk mengelola state global aplikasi, seperti tema.
class AppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// Mendapatkan mode tema saat ini.
  ThemeMode get themeMode => _themeMode;

  /// Mengatur mode tema dan memberi tahu listener tentang perubahan.
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}