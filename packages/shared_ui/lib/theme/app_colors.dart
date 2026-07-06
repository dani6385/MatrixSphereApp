import 'package:flutter/material.dart';

/// Kumpulan warna kustom yang digunakan di seluruh aplikasi.
/// Ini memungkinkan konsistensi tema dan kemudahan dalam melakukan perubahan.
class AppColors {
  // Private constructor agar kelas ini tidak bisa diinstansiasi.
  AppColors._();

  // --- Warna Utama (Branding) ---
  /// Warna dasar utama yang digunakan untuk menghasilkan skema warna.
  static const Color primary = Color(0xFF00897B); // Diubah ke Teal
  static const Color primaryDarker = Color(0xFF00695C); // Teal yang lebih gelap
  static const Color primarySeedColor = Color(0xFF00897B); // Diubah ke Teal
  static const Color textDark = Color(0xFF9E9E9E);
  // Warna transparan untuk kebutuhan overlay atau background.
  static const Color transparentlight = Colors.transparent;
  static const Color transparentDark = Colors.transparent;

  /// Warna sekunder, bisa digunakan untuk aksen atau CTA (Call to Action).
  static const Color secondary = Color(
    0xFFF9A825,
  ); // Contoh: Kuning untuk kontras

  /// Warna untuk teks atau background "Flash Sale".
  static const Color flashSaleCountdownBg = Color(
    0xFFE0F2F1,
  ); // Teal sangat muda
  static const Color flashSaleCountdownText = Color(0xFF00897B);

  // --- Warna Latar Belakang & Permukaan ---
  /// Warna latar belakang utama untuk Scaffold di mode terang.
  static const Color background = Color(0xFF9E9E9E);
  static const Color backgroundLight = Color(0xFFF7F8FA);

  /// Warna dasar untuk komponen seperti Card di mode terang.
  static const Color surface = Colors.white;

  /// Warna latar belakang untuk kontainer ikon atau input field.
  static const Color iconBackground = Color(0xFFF0F0F0); // Abu-abu muda

  // --- Warna Tambahan ---
  /// Warna untuk border atau divider yang subtle.
  static const Color border = Color(0xFFEEEEEE);

  /// Warna utama untuk ikon.
  static const Color iconPrimary = Color(0xFF212121);

  /// Warna teks utama (hitam pekat).
  static const Color textPrimary = Color(0xFF212121);

  /// Warna teks sekunder (abu-abu).
  static const Color textSecondary = Color(0xFF757575);

  /// Warna untuk animasi ripple (semi-transparan).
  static Color get beginend => const Color(0xFF00897B).withAlpha(3);
}
