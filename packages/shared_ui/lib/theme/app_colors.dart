import 'package:flutter/material.dart';

/// Kumpulan warna kustom yang digunakan di seluruh aplikasi.
/// Ini memungkinkan konsistensi tema dan kemudahan dalam melakukan perubahan.
class AppColors {
  // Private constructor agar kelas ini tidak bisa diinstansiasi.
  AppColors._();

  // --- Warna Utama (Branding) ---
  /// Warna dasar utama yang digunakan untuk menghasilkan skema warna.
  static const Color primary = Color(0xFF00668B);
  static const Color primaryDarker = Color(0xFF00695C); // Warna ini digunakan untuk gradien
  static const Color primarySeedColor = Color(0xFF00668B);

  // --- Warna Latar Belakang & Permukaan ---
  /// Warna latar belakang utama untuk Scaffold di mode terang.
  static const Color backgroundLight = Color(0xFFF7F8FA);
  /// Warna dasar untuk komponen seperti Card di mode terang.
  static const Color surface = Colors.white;

  // --- Warna Teks & Ikon ---
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF5C5C5C);
  static const Color textTertiary = Color(0xFF9E9E9E);

  // --- Warna Lainnya ---
  static const Color border = Color(0xFFEEEEEE);
  static const Color divider = Color(0xFFF0F0F0);

  // --- Warna Status & Kategori ---
  // Member (menggunakan primary)
  static const Color statusMemberBg = Color(0xFFE0F2F1);
  // Voucher
  static const Color statusVoucher = Color(0xFF0277BD);
  static const Color statusVoucherBg = Color(0xFFE3F2FD);
  // Scan QR
  static const Color statusScanQr = Color(0xFF6A1B9A);
  static const Color statusScanQrBg = Color(0xFFF3E5F5);
  // Bayar QR
  static const Color statusPayQr = Color(0xFFE65100);
  static const Color statusPayQrBg = Color(0xFFFFF3E0);
  // Trial
  static const Color statusTrial = Color(0xFF558B2F);
  static const Color statusTrialBg = Color(0xFFF1F8E9);
}