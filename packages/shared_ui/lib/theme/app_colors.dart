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

  /// Warna sekunder, bisa digunakan untuk aksen atau CTA (Call to Action).
  static const Color secondary = Color(0xFFF9A825); // Contoh: Kuning untuk kontras

  /// Warna untuk teks atau background "Flash Sale".
  static const Color flashSaleCountdownBg = Color(0xFFE0F2F1); // Teal sangat muda
  static const Color flashSaleCountdownText = Color(0xFF00897B);

  // --- Warna Latar Belakang & Permukaan ---
  /// Warna latar belakang utama untuk Scaffold di mode terang.
  static const Color backgroundLight = Color(0xFFF7F8FA);
  /// Warna dasar untuk komponen seperti Card di mode terang.
  static const Color surface = Colors.white;

  // --- Warna Tambahan ---
  /// Warna untuk border atau divider yang subtle.
  static const Color border = Color(0xFFEEEEEE);
  /// Warna teks utama (hitam pekat).
  static const Color textPrimary = Color(0xFF212121);
  /// Warna teks sekunder (abu-abu).
  static const Color textSecondary = Color(0xFF757575);
}
