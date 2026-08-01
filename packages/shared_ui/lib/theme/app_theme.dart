import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart'; // Impor tipografi

// Definisikan tema aplikasi, terinspirasi oleh implementasi Material 3 di Compose.
// Ini menyediakan ThemeData terpusat untuk mode terang dan gelap.

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: kLightBackground,
      primaryColor: kBrandSecondary,
      colorScheme: const ColorScheme.light(
        primary: kBrandSecondary,
        secondary: kBrandPrimary,
        tertiary: kBrandTertiary,
        surface: kLightSurface,
        onPrimary: kLightSurface,
        onSecondary: kLightSurface,
        onTertiary: kLightSurface,
        onSurface: kLightTextPrimary,
        outline: kLightBorder,
        onSurfaceVariant: kLightTextSecondary,
      ),
      textTheme: kTextTheme.apply(
        // Terapkan TextTheme
        bodyColor: kLightTextPrimary, // Warna default untuk body
        displayColor: kLightTextPrimary, // Warna default untuk headline/display
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kLightSurface,
        elevation: 0,
        iconTheme: const IconThemeData(color: kLightTextPrimary),
        // Gunakan gaya dari TextTheme untuk konsistensi
        titleTextStyle:
            kTextTheme.titleLarge?.copyWith(color: kLightTextPrimary),
      ),
      dividerColor: kLightBorder,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kDarkBackground,
      primaryColor: kBrandPrimary,
      colorScheme: const ColorScheme.dark(
        primary: kBrandPrimary,
        secondary: kBrandSecondary,
        tertiary: kBrandTertiary,
        surface: kDarkSurface,
        onPrimary: kDarkTextPrimary,
        onSecondary: kDarkTextPrimary,
        onTertiary: kDarkTextPrimary,
        onSurface: kDarkTextPrimary,
        outline: kDarkBorder,
        onSurfaceVariant: kDarkTextSecondary,
      ),
      textTheme: kTextTheme.apply(
        // Terapkan TextTheme
        bodyColor: kDarkTextPrimary, // Warna default untuk body
        displayColor:
            kDarkTextSecondary, // Warna default untuk headline/display
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kDarkSurface,
        elevation: 0,
        iconTheme: const IconThemeData(color: kDarkTextPrimary),
        // Gunakan gaya dari TextTheme untuk konsistensi
        titleTextStyle:
            kTextTheme.titleLarge?.copyWith(color: kDarkTextPrimary),
      ),
      dividerColor: kDarkBorder,
    );
  }
}

TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;

extension AppThemeExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextStyle? get titleLarge => textTheme.titleLarge;
  TextStyle? get titleMedium => textTheme.titleMedium;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get headlineMedium => textTheme.headlineMedium;
}
