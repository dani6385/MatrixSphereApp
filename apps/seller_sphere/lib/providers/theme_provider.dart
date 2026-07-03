import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const THEME_STATUS = "THEME_STATUS";
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  /// Mengubah tema dan menyimpan preferensi ke perangkat.
  void toggleTheme(bool isOn) async {
    _isDarkMode = isOn;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, isOn);
    notifyListeners();
  }

  /// Memuat preferensi tema saat aplikasi dimulai.
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Default ke false (light mode) jika tidak ada preferensi yang tersimpan.
    _isDarkMode = prefs.getBool(THEME_STATUS) ?? false;
    notifyListeners();
  }
}