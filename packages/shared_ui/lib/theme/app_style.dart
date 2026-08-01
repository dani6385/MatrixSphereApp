import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';

/// A collection of pre-defined visual styles for the application.
///
/// This class centralizes common decorations, button styles, and text styles
/// to ensure visual consistency across the app. By using these shared styles,
/// you can easily update the look and feel of the entire application from
/// one place.
///
/// The styles are designed to work in conjunction with the app's `ThemeData`,
/// often pulling from the global `TextTheme` and applying specific colors
/// from `AppColors`.
class AppStyles {
  // Dekorasi untuk kartu utama
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: kDarkSecondary,
    borderRadius: BorderRadius.circular(12),
  );

  // Dekorasi untuk container bagian dalam (jam dan tanggal)
  static final BoxDecoration innerCardDecoration = BoxDecoration(
    color: kDarkBackground,
    borderRadius: BorderRadius.circular(8),
  );

  // Gaya untuk OutlinedButton
  static final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: kDarkTextPrimary,
    side: const BorderSide(color: kDarkTextSecondary),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Gaya untuk TextButton di AppBar
  static final ButtonStyle appBarTextButtonStyle = TextButton.styleFrom(
    foregroundColor: kDarkTextPrimary,
    backgroundColor: kDarkSecondary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  // --- Gaya Tema Gelap (Dark Theme) ---

  /// Warna latar belakang default untuk Scaffold di sebagian besar layar utama.
  static const Color darkScaffoldBackgroundColor = kBrandTertiary;

  /// Gaya AppBar default untuk konsistensi di seluruh aplikasi.
  static final AppBarTheme darkAppBarTheme = AppBarTheme(
    backgroundColor: kDarkSecondary,
    elevation: 2,
    iconTheme: const IconThemeData(color: kLightTextPrimary), // Warna ikon (misal: hamburger menu)
    titleTextStyle: const TextStyle(color: kLightTextPrimary, fontSize: 20, fontWeight: FontWeight.w500),
  );

  // --- Gaya Tema Terang (Light Theme) ---

  /// Warna latar belakang default untuk Scaffold pada tema terang.
  static const Color lightScaffoldBackgroundColor = kLightBackground;

  /// Gaya AppBar untuk tema terang.
  static final AppBarTheme lightAppBarTheme = AppBarTheme(
    backgroundColor: kLightAppBar,
    elevation: 1,
    iconTheme: const IconThemeData(color: kLightTextPrimary),
    titleTextStyle: const TextStyle(color: kLightTextPrimary, fontSize: 20, fontWeight: FontWeight.w500),
  );

  /// Gaya untuk OutlinedButton pada tema terang.
  static final ButtonStyle lightOutlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: kLightTextPrimary,
    side: const BorderSide(color: kLightBorder),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Metode untuk mendapatkan gaya teks, bergantung pada TextTheme

  // Untuk header kecil seperti 'Karyawan Aktif'
  static TextStyle cardHeader(TextTheme textTheme) =>
      textTheme.bodySmall!.copyWith(color: kDarkTextSecondary);

  // Untuk judul utama seperti 'Matrix Admin'
  static TextStyle primaryTitle(TextTheme textTheme) =>
      textTheme.titleMedium!.copyWith(color: kDarkTextPrimary);

  // Untuk subjudul sekunder seperti ID karyawan
  static TextStyle secondarySubtitle(TextTheme textTheme) =>
      textTheme.bodySmall!.copyWith(color: kDarkTextSecondary);

  // Untuk tampilan jam yang besar
  static TextStyle timeDisplay(TextTheme textTheme) => textTheme.displaySmall!
      .copyWith(color: kDarkTextPrimary, fontWeight: FontWeight.bold);

  // Untuk tampilan tanggal di bawah jam
  static TextStyle dateDisplay(TextTheme textTheme) =>
      textTheme.bodyMedium!.copyWith(color: kDarkTextSecondary);
      
}
