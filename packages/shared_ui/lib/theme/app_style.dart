// lib/core/theme/app_styles.dart

import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';

/// Kumpulan gaya visual dan tema terpusat untuk aplikasi.
///
/// Kelas ini mengelola dekorasi, gaya tombol, dan konfigurasi tema
/// secara konsisten agar mudah dikelola dari satu tempat.
class AppStyles {
  // --- Dekorasi Umum ---
  static const EdgeInsets defaultScreenPadding = EdgeInsets.all(16.0);

  /// Gaya teks standar untuk body medium.
  static const TextStyle headlineMedium =
      TextStyle(fontSize: 28, color: kDarkTextPrimary);

  /// Gaya teks standar untuk body medium.
  static const TextStyle headlineSmall =
      TextStyle(fontSize: 24, color: kDarkTextPrimary);

  /// Gaya teks standar untuk body medium.
  static const TextStyle bodyMedium =
      TextStyle(fontSize: 14, color: kDarkTextPrimary);

  /// Dekorasi untuk kartu utama
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: kDarkSecondary,
        borderRadius: BorderRadius.circular(12),
      );

  /// Dekorasi untuk container bagian dalam (jam dan tanggal)
  static BoxDecoration get innerCardDecoration => BoxDecoration(
        color: kDarkBackground,
        borderRadius: BorderRadius.circular(8),
      );

  // --- Gaya Tombol ---

  /// Gaya untuk OutlinedButton standar
  static ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: kDarkTextPrimary,
        side: const BorderSide(color: kDarkTextSecondary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );

  /// Gaya untuk TextButton di AppBar
  static ButtonStyle get appBarTextButtonStyle => TextButton.styleFrom(
        foregroundColor: kDarkTextPrimary,
        backgroundColor: kDarkSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      );

  // --- Gaya Tema Gelap (Dark Theme) ---

  /// Warna latar belakang default untuk Scaffold pada tema gelap.
  static List<Color> darkScaffoldBackgroundColor(BuildContext context) => [
        Theme.of(context).colorScheme.surface,
        Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
      ];

  /// Gaya AppBar default untuk tema gelap.
  static AppBarTheme get darkAppBarTheme => AppBarTheme(
        backgroundColor: kDarkSecondary,
        elevation: 2,
        iconTheme: const IconThemeData(color: kLightTextPrimary),
        titleTextStyle: const TextStyle(
          color: kLightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      );

  // --- Gaya Tema Terang (Light Theme) ---

  /// Warna latar belakang default untuk Scaffold pada tema terang.
  static const Color lightScaffoldBackgroundColor = kLightBackground;

  /// Gaya AppBar untuk tema terang.
  static AppBarTheme get lightAppBarTheme => AppBarTheme(
        backgroundColor: kLightAppBar,
        elevation: 1,
        iconTheme: const IconThemeData(color: kLightTextPrimary),
        titleTextStyle: const TextStyle(
          color: kLightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      );

  /// Gaya untuk OutlinedButton pada tema terang.
  static ButtonStyle get lightOutlinedButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: kLightTextPrimary,
        side: const BorderSide(color: kLightBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );

  // --- Gaya Teks Dinamis (Berdasarkan TextTheme) ---

  /// Untuk header kecil seperti 'Karyawan Aktif'
  static TextStyle cardHeader(TextTheme textTheme) =>
      textTheme.bodySmall!.copyWith(color: kDarkTextSecondary);

  /// Untuk judul utama seperti 'Matrix Admin'
  static TextStyle primaryTitle(TextTheme textTheme) =>
      textTheme.titleMedium!.copyWith(color: kDarkTextPrimary);

  /// Untuk subjudul sekunder seperti ID karyawan
  static TextStyle secondarySubtitle(TextTheme textTheme) =>
      textTheme.bodySmall!.copyWith(color: kDarkTextSecondary);

  /// Untuk tampilan jam yang besar
  static TextStyle timeDisplay(TextTheme textTheme) => textTheme.displaySmall!
      .copyWith(color: kDarkTextPrimary, fontWeight: FontWeight.bold);

  /// Untuk tampilan tanggal di bawah jam
  static TextStyle dateDisplay(TextTheme textTheme) =>
      textTheme.bodyMedium!.copyWith(color: kDarkTextSecondary);

  /// Gaya untuk Elevated Button standar
  static ButtonStyle get elevatedButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: kBrandPrimary,
        foregroundColor: kBrandWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );

  static get bodyLarge => TextStyle(fontSize: 16, color: kDarkTextPrimary);

  static TextStyle? get titleLarge =>
      const TextStyle(fontSize: 22, color: kDarkTextPrimary);

  static get titleMedium =>
      const TextStyle(fontSize: 18, color: kDarkTextPrimary);

  static Color? get primaryContainer => kBrandPrimary.withOpacity(0.1);

  static get bodySmall => const TextStyle(fontSize: 12, color: kDarkTextPrimary);

  static ButtonStyle? get filledButton => FilledButton.styleFrom(
        backgroundColor: kBrandPrimary,
        foregroundColor: kBrandWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      );

  static TextStyle? get labelLarge => const TextStyle(fontSize: 14, color: kDarkTextPrimary);
  
      

}
