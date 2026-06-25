import 'package:flutter/material.dart';

/// Kelas yang berisi konfigurasi tema untuk aplikasi.
class AppTheme {
  // Private constructor agar kelas ini tidak bisa diinstansiasi.
  AppTheme._();

  /// Tema terang untuk aplikasi.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: const Color(0xFF007BFF),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF007BFF),
        brightness: Brightness.light,
      ),

      // Konfigurasi AppBar
      appBarTheme: const AppBarTheme(
        elevation: 1,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Konfigurasi BottomNavigationBar
      // Didesain untuk 5 item tanpa nama/label.
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white, // atau colorScheme.surface
        // Warna untuk item yang sedang aktif
        selectedItemColor: const Color(0xFF007BFF), // atau colorScheme.primary
        // Warna untuk item yang tidak aktif
        unselectedItemColor: Colors.grey.shade600,
        // Sembunyikan label untuk item yang dipilih
        showSelectedLabels: false,
        // Sembunyikan label untuk item yang tidak dipilih
        showUnselectedLabels: false,
        // Tipe 'fixed' memastikan semua item terlihat dan tidak bergeser.
        // Ini adalah pilihan yang tepat untuk 4-5 item.
        type: BottomNavigationBarType.fixed,
        elevation: 8.0,
      ),

      // Konfigurasi Card
      cardTheme: CardThemeData(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        surfaceTintColor: Colors.white,
      ),
    );
  }
}