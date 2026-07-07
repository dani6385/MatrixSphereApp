import 'package:flutter/material.dart';
import 'app_colors.dart';

// Definisi skema warna untuk tema gelap
final ColorScheme _darkColorScheme = ColorScheme.dark(
  primary: primary,
  secondary: secondary,
  tertiary: tertiary,
  background: background,
  surface: surface, // Ini adalah warna untuk Card, Dialog, dll.
  onPrimary: textPrimary,
  onSecondary: textPrimary,
  onTertiary: textPrimary,
  onBackground: textPrimary,
  onSurface: textPrimary, // Warna teks di atas surface
  surfaceVariant: border,
  onSurfaceVariant: textSecondary,
  error: error,
  onError: textPrimary,
);

// Definisi skema warna untuk tema terang
final ColorScheme _lightColorScheme = ColorScheme.light(
  primary: secondary,
  secondary: primary,
  tertiary: tertiary,
  background: lightBackground,
  surface: lightSurface,
  onPrimary: lightTextPrimary,
  onSecondary: lightTextPrimary,
  onTertiary: lightTextPrimary,
  onBackground: lightTextPrimary,
  onSurface: lightTextPrimary,
  surfaceVariant: lightBorder,
  onSurfaceVariant: lightTextSecondary,
  error: error,
  onError: lightTextPrimary,
);

/// Fungsi untuk mendapatkan ThemeData berdasarkan mode gelap/terang
ThemeData getAppTheme(bool isDarkMode) {
  final colorScheme = isDarkMode ? _darkColorScheme : _lightColorScheme;
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    // Secara eksplisit mengatur beberapa warna tema untuk konsistensi
    scaffoldBackgroundColor: colorScheme.background,
    cardColor: colorScheme.surface,
    dialogBackgroundColor: colorScheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.background,
      elevation: 0,
    ),
  );
}

/// Widget MyApplicationTheme yang lama telah dihapus karena menyebabkan
/// masalah nested MaterialApp. Gunakan getAppTheme() di MaterialApp utama.
