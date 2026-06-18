import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_assets/shared_assets.dart';

class AppTheme {
  // Tema untuk Mode Terang (Light Mode)
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.lightSurface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary, // Teks di atas warna primer
        onSecondary: Colors.white,         // Teks di atas warna sekunder
        onSurface: AppColors.textOnLight, // Teks di atas background utama
        onError: Colors.white,
      ),

      // Tema Teks menggunakan Google Fonts (Poppins)
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme).copyWith(
        bodyMedium: const TextStyle(color: AppColors.textOnLight),
        headlineMedium: const TextStyle(color: AppColors.textOnLight, fontWeight: FontWeight.bold),
      ),

      // Tema AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary, 
        foregroundColor: AppColors.textOnPrimary, // Warna untuk judul dan ikon
        elevation: 2,
        iconTheme: IconThemeData(color: AppColors.textOnPrimary),
      ),

      // Tema Tombol
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary, // Warna oranye untuk aksi utama
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Tema Card
      cardTheme: CardThemeData( // <-- PERBAIKAN DI SINI
        elevation: 1,
        color: AppColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Tema Input
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2.0)
        )
      ),
    );
  }

  // Tema untuk Mode Gelap (Dark Mode)
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary, 
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: Colors.white,
        onSurface: AppColors.textOnDark,
        onError: Colors.white,
      ),

      // Tema Teks menggunakan Google Fonts (Poppins)
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        bodyMedium: const TextStyle(color: AppColors.textOnDark),
        headlineMedium: const TextStyle(color: AppColors.textOnDark, fontWeight: FontWeight.bold),
      ),
      
      // Tema AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.textOnDark,
        elevation: 0, // Lebih flat di mode gelap
        iconTheme: IconThemeData(color: AppColors.textOnDark),
      ),

      // Tema Tombol
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Tema Card
      cardTheme: CardThemeData( // <-- DAN DI SINI
        elevation: 2, // Dibuat sedikit lebih menonjol
        color: AppColors.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Tema Input
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.secondary, width: 2.0)
        )
      ),
    );
  }
}
