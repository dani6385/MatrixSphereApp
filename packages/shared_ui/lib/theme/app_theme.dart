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
  //TextStyle? get titleLarge => textTheme.titleLarge;
  //TextStyle? get titleMedium => textTheme.titleMedium;
  //TextStyle? get bodyLarge => textTheme.bodyLarge;
  //TextStyle? get bodyMedium => textTheme.bodyMedium;
  //TextStyle? get bodySmall => textTheme.bodySmall;
  //TextStyle? get headlineMedium => textTheme.headlineMedium;
  //TextStyle? get headlineSmall => textTheme.headlineSmall;
  //TextStyle? get headlineLarge => textTheme.headlineLarge;
  //TextStyle? get labelLarge => textTheme.labelLarge;
  //TextStyle? get labelMedium => textTheme.labelMedium;
  //TextStyle? get labelSmall => textTheme.labelSmall;
  //TextStyle? get displayLarge => textTheme.displayLarge;
  //TextStyle? get displayMedium => textTheme.displayMedium;
  //TextStyle? get displaySmall => textTheme.displaySmall;
  Color get cardColor => colorScheme.surface; //panggil context.cardColor
  Color get primary => colorScheme.primary;
  Color get onPrimary => colorScheme.onPrimary;
  Color get secondary => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get tertiary => colorScheme.tertiary;
  Color get onTertiary => colorScheme.onTertiary;
  Color get surface => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;
  Color get outline => colorScheme.outline;
  Color get onSurfaceVariant => colorScheme.onSurfaceVariant;
  Color get background => colorScheme.background;
  Color get onBackground => colorScheme.onBackground;
  Color get error => colorScheme.error;
  Color get onError => colorScheme.onError;
  Color get surfaceVariant => colorScheme.surfaceVariant;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get onSecondaryContainer => colorScheme.onSecondaryContainer;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get onTertiaryContainer => colorScheme.onTertiaryContainer;
  Color get errorContainer => colorScheme.errorContainer;
  Color get onErrorContainer => colorScheme.onErrorContainer;
  Color get inversePrimary => colorScheme.inversePrimary;
  Color get inverseSurface => colorScheme.inverseSurface;
  Color get onInverseSurface => colorScheme.onInverseSurface;
  Color get scrim => colorScheme.scrim;
  Color get shadow => colorScheme.shadow;
  Color get surfaceTint => colorScheme.surfaceTint;
  Color get surfaceContainerHighest => colorScheme.surfaceContainerHighest;
  Color get surfaceContainerHigh => colorScheme.surfaceContainerHigh;
  Color get surfaceContainer => colorScheme.surfaceContainer;
  Color get surfaceContainerLow => colorScheme.surfaceContainerLow;
  Color get surfaceContainerLowest => colorScheme.surfaceContainerLowest;
  Color get surfaceBright => colorScheme.surfaceBright;
  Color get primaryColor => colorScheme.primary;
  Color get dividerColor => Theme.of(this).dividerColor;
  
  
  
}
