import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  // Tema tidak bisa diinstansiasi
  AppTheme._();

  // Nama font family yang dideklarasikan di pubspec.yaml
  static const String _fontFamily = 'Poppins';

  // --- DEFINISI TEXT THEME KUSTOM ---
  static const TextTheme _textTheme = TextTheme(
    // Contoh kustomisasi beberapa gaya teks.
    // Flutter akan menggunakan font family ini untuk semua gaya jika tidak ditentukan.
    displayLarge: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.bold),
    displaySmall: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.bold),
    headlineLarge: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.bold),
    headlineMedium: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.bold),
    titleLarge: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600), // SemiBold
    titleMedium: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w500), // Medium
    bodyLarge: TextStyle(fontFamily: _fontFamily),
    bodyMedium: TextStyle(fontFamily: _fontFamily),
    bodySmall: TextStyle(fontFamily: _fontFamily),
    labelLarge: TextStyle(fontFamily: _fontFamily, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontFamily: _fontFamily),
    labelSmall: TextStyle(fontFamily: _fontFamily),
  );


  // --- TEMA TERANG (LIGHT THEME) ---

  /// Skema warna untuk mode terang, dihasilkan dari seed color.
  static final ColorScheme _lightColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primarySeedColor,
    brightness: Brightness.light,
    // --- TIMPA WARNA DI SINI ---
  ).copyWith(
    // Contoh: Menggunakan warna merah yang lebih spesifik untuk error.
    error: const Color(0xFFD32F2F), // Merah yang lebih pekat
    onError: Colors.white, // Warna teks di atas background error
  );

  /// ThemeData untuk mode terang.
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: _fontFamily, // Terapkan font family default
    colorScheme: _lightColorScheme,
    textTheme: _textTheme.apply(bodyColor: _lightColorScheme.onSurface), // Terapkan TextTheme
    scaffoldBackgroundColor: _lightColorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: _lightColorScheme.onSurface,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      color: _lightColorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightColorScheme.primary,
        foregroundColor: _lightColorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    // --- TEMA UNTUK INPUT DECORATION (TEXTFIELD) ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightColorScheme.onSurface.withAlpha(4),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      // Border default saat tidak ada interaksi
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none, // Tidak ada border, mengandalkan warna fill
      ),
      // Border saat TextField aktif (enabled) tapi tidak dalam fokus
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: _lightColorScheme.onSurface.withAlpha(2)),
      ),
      // Border saat TextField dalam fokus
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: _lightColorScheme.primary, width: 2.0),
      ),
      // Gaya untuk label saat di atas (floating)
      floatingLabelStyle: TextStyle(color: _lightColorScheme.primary),
    ),
    // --- TEMA UNTUK BOTTOM NAVIGATION BAR ---
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _lightColorScheme.surface,
      elevation: 4.0,
      selectedItemColor: _lightColorScheme.primary,
      unselectedItemColor: _lightColorScheme.onSurface.withAlpha(7),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      type: BottomNavigationBarType.fixed,
    ),
    // --- TEMA UNTUK TAB BAR ---
    tabBarTheme: TabBarThemeData(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.0, color: _lightColorScheme.primary),
      ),
      labelColor: _lightColorScheme.primary,
      unselectedLabelColor: _lightColorScheme.onSurface.withAlpha(7),
      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: _fontFamily),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontFamily: _fontFamily),
    ),
    // --- TEMA UNTUK DIALOG ---
    dialogTheme: DialogThemeData(
      backgroundColor: _lightColorScheme.surface,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      titleTextStyle: _textTheme.titleLarge?.copyWith(color: _lightColorScheme.onSurface),
      contentTextStyle: _textTheme.bodyMedium?.copyWith(color: _lightColorScheme.onSurfaceVariant),
      actionsPadding: const EdgeInsets.all(16.0),
    ),
    // --- TEMA UNTUK SNACKBAR ---
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _lightColorScheme.onSurface,
      contentTextStyle: TextStyle(color: _lightColorScheme.surface, fontFamily: _fontFamily, fontWeight: FontWeight.w500),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4.0,
    ),
    // --- TEMA UNTUK CHIP ---
    chipTheme: ChipThemeData(
      backgroundColor: _lightColorScheme.secondaryContainer,
      labelStyle: TextStyle(
        color: _lightColorScheme.onSecondaryContainer,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
      ),
      shape: const StadiumBorder(), // Bentuk pil yang umum untuk chip
      side: BorderSide.none,
    ),
    // --- TEMA UNTUK FLOATING ACTION BUTTON ---
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _lightColorScheme.primary,
      foregroundColor: _lightColorScheme.onPrimary,
      shape: const CircleBorder(),
      elevation: 4.0,
    ),
  );


  // --- TEMA GELAP (DARK THEME) ---

  /// Skema warna untuk mode gelap, dihasilkan dari seed color yang sama.
  static final ColorScheme _darkColorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primarySeedColor,
    brightness: Brightness.dark,
    // --- TIMPA WARNA DI SINI ---
  ).copyWith(
    // Contoh: Menggunakan warna merah yang lebih terang agar terlihat jelas di mode gelap.
    error: const Color(0xFFEF9A9A),
    onError: const Color(0xFF611010), // Warna teks gelap di atas background error terang
  );

  /// ThemeData untuk mode gelap.
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: _fontFamily, // Terapkan font family default
    colorScheme: _darkColorScheme,
    textTheme: _textTheme.apply(bodyColor: _darkColorScheme.onSurface), // Terapkan TextTheme
    scaffoldBackgroundColor: _darkColorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: _darkColorScheme.surface, // Tetap surface untuk dark mode
      foregroundColor: _darkColorScheme.onSurface,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      color: _darkColorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkColorScheme.primary,
        foregroundColor: _darkColorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    // --- TEMA UNTUK INPUT DECORATION (TEXTFIELD) ---
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkColorScheme.onSurface.withAlpha(6),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      // Border default saat tidak ada interaksi
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      // Border saat TextField aktif (enabled) tapi tidak dalam fokus
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: _darkColorScheme.onSurface.withAlpha(3)),
      ),
      // Border saat TextField dalam fokus
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: _darkColorScheme.primary, width: 2.0),
      ),
      // Gaya untuk label saat di atas (floating)
      floatingLabelStyle: TextStyle(color: _darkColorScheme.primary),
    ),
    // --- TEMA UNTUK BOTTOM NAVIGATION BAR ---
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: _darkColorScheme.surface,
      elevation: 4.0,
      selectedItemColor: _darkColorScheme.primary,
      unselectedItemColor: _darkColorScheme.onSurface.withAlpha(7),
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      type: BottomNavigationBarType.fixed,
    ),
    // --- TEMA UNTUK TAB BAR ---
    tabBarTheme: TabBarThemeData(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 2.0, color: _darkColorScheme.primary),
      ),
      labelColor: _darkColorScheme.primary,
      unselectedLabelColor: _darkColorScheme.onSurface.withAlpha(7),
      labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontFamily: _fontFamily),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontFamily: _fontFamily),
    ),
    // --- TEMA UNTUK DIALOG ---
    dialogTheme: DialogThemeData(
      backgroundColor: _darkColorScheme.surface,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      titleTextStyle: _textTheme.titleLarge?.copyWith(color: _darkColorScheme.onSurface),
      contentTextStyle: _textTheme.bodyMedium?.copyWith(color: _darkColorScheme.onSurfaceVariant),
      actionsPadding: const EdgeInsets.all(16.0),
    ),
    // --- TEMA UNTUK SNACKBAR ---
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _darkColorScheme.onSurface,
      contentTextStyle: TextStyle(color: _darkColorScheme.surface, fontFamily: _fontFamily, fontWeight: FontWeight.w500),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4.0,
    ),
    // --- TEMA UNTUK CHIP ---
    chipTheme: ChipThemeData(
      backgroundColor: _darkColorScheme.secondaryContainer,
      labelStyle: TextStyle(
        color: _darkColorScheme.onSecondaryContainer,
        fontFamily: _fontFamily,
        fontWeight: FontWeight.w500,
      ),
      shape: const StadiumBorder(), // Bentuk pil yang umum untuk chip
      side: BorderSide.none,
    ),
    // --- TEMA UNTUK FLOATING ACTION BUTTON ---
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _darkColorScheme.primaryContainer,
      foregroundColor: _darkColorScheme.onPrimaryContainer,
      shape: const CircleBorder(),
      elevation: 4.0,
    ),
  );
}