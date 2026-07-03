import 'package:flutter/material.dart';

/// Kelas statis untuk menyimpan semua palet warna aplikasi.
/// Ini memudahkan perubahan tema secara global.
class AppColors {
  // Warna Utama (Primary)
  static const Color primary = Color(0xFF007A64); // Warna hijau khas MatrixSphere
  static const Color secondary = Color(0xFF00C896); // Warna aksen (notifikasi/status)
  
  // Warna Latar Belakang
  static const Color background = Color(0xFFF8F9FA); // Background halaman
  static const Color backgroundLight = Color(0xFFFFFFFF); // Background putih bersih
  static const Color surface = Color(0xFFFFFFFF); // Kartu/Widget
  
  // Warna Teks
  static const Color textPrimary = Color(0xFF1A1A1A); // Teks utama (hitam gelap)
  static const Color textSecondary = Color(0xFF757575); // Teks pendukung (abu-abu)
  
  // Warna Status/Feedback
  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  
  // Warna Ikon (Utilitas)
  static const Color iconPrimary = Color(0xFF1A1A1A);
  static const Color iconBackground = Color(0xFFF1F3F5);

  // Warna khusus untuk mode gelap (opsional)
  static const Color darkBackground = Color(0xFF161B22);
}