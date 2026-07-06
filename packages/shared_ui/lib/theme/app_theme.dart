import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
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

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // --- Skema Warna Utama (Mode Gelap) ---
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primarySeedColor,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: const Color(0xFF1E1E1E), // Warna permukaan lebih gelap
        background: const Color(0xFF121212), // Latar belakang standar gelap
        onPrimary: Colors.white,
        onSurface: Colors.white,
      ),

      // --- Latar Belakang Scaffold ---
      scaffoldBackgroundColor: const Color(0xFF121212),

      // --- Tipografi (dengan warna terang) ---
      textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme),

      // --- Tema AppBar ---
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFF121212),
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // --- Tema Card ---
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF1E1E1E),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[800]!, width: 1),
        ),
      ),

      // --- Tema Input ---
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        hintStyle: TextStyle(color: Colors.grey[600]),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[800]!, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[800]!, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),

      // Tema lainnya bisa disesuaikan di sini jika perlu
    );
  }

  static Color get primary => const Color(0xFF00897B);
  static Color get secondary => const Color(0xFFF9A825);
  static Color get error => const Color(0xFFD32F2F);
  static Color get warning => const Color(0xFFFFA000);
  static Color get success => const Color(0xFF4CAF50); // Warna hijau untuk status sukses
  static Color get backgroundLight => const Color(0xFFF5F5F5);
  static Color get primaryContainer => const Color(0xFFE0F2F1); // Warna kontainer terang untuk primary
}
