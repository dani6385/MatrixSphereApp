import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Kelas AppTheme mendefinisikan tema visual untuk seluruh aplikasi.
/// Ini mencakup skema warna, tipografi, dan tema untuk berbagai widget.
class AppTheme {
  // Private constructor untuk mencegah instansiasi.
  AppTheme._();

  /// Tema terang untuk aplikasi.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // --- Skema Warna Utama ---
      colorScheme: ColorScheme.fromSeed(
        seedColor:
            AppColors.primarySeedColor, // Menggunakan warna Teal sebagai dasar
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        // Properti 'background' sudah usang, dihapus.
        surface: AppColors.surface, // Permukaan putih untuk Card, dll.
        onPrimary:
            Colors.white, // Teks/ikon di atas warna primary (misal: di Button)
        onSurface: AppColors.textPrimary, // Teks utama di atas warna surface
      ),

      // --- Latar Belakang Scaffold ---
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // --- Tipografi ---
      textTheme: GoogleFonts.dmSansTextTheme(),

      // --- Tema AppBar ---
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0, // Hapus perubahan warna saat scroll
        backgroundColor:
            AppColors.backgroundLight, // Latar AppBar sama dengan Scaffold
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // --- Tema Card ---
      cardTheme: CardThemeData(
        elevation: 0.5,
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),

      // --- Tema Input (untuk SearchBar) ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),

      // --- Tema Tombol Navigasi Bawah ---
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.primary, // Latar belakang Teal
        selectedItemColor: Colors.white, // Ikon dan label yang aktif
        unselectedItemColor: Colors.white70, // Ikon dan label yang tidak aktif
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false, // Sembunyikan label
        showUnselectedLabels: false, // Sembunyikan label
      ),

      // --- Tema ElevatedButton ---
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
