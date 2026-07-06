import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. Definisikan Provider Riverpod Global
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

// 2. Buat StateNotifier untuk mengelola state tema
class ThemeNotifier extends StateNotifier<bool> {
  static const _themeStatus = "THEME_STATUS";

  // Inisialisasi state awal ke false (light mode) dan langsung muat tema tersimpan
  ThemeNotifier() : super(false) {
    _loadTheme();
  }

  /// Mengubah tema dan menyimpan preferensi ke perangkat.
  void toggleTheme(bool isOn) async {
    state = isOn;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeStatus, isOn);
  }

  /// Memuat preferensi tema saat aplikasi dimulai.
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    // Muat state, default ke false jika tidak ada yang tersimpan
    state = prefs.getBool(_themeStatus) ?? false;
  }
}
