import 'package:flutter/material.dart';

/// Palet Warna Modern & Profesional untuk Aplikasi Hotspot
/// Menggunakan skema warna Deep Slate Blue dengan aksen Carrot Orange.
class AppColors {
  // Warna Primer & Sekunder
  static const Color primary = Color(0xFF2C3E50); // Deep Slate Blue (Biru Tua Keabuan)
  static const Color secondary = Color(0xFFE67E22); // Carrot Orange (Oranye Wortel)

  // Warna Latar & Permukaan (Mode Terang)
  static const Color lightBackground = Color(0xFFF5F7FA); // Whisper (Abu-abu Sangat Terang)
  static const Color lightSurface = Colors.white;

  // Warna Latar & Permukaan (Mode Gelap)
  static const Color darkBackground = Color(0xFF1C2833); // Dark Slate (Biru Sangat Gelap)
  static const Color darkSurface = Color(0xFF273746); // Abbey (Abu-abu Gelap)

  // Warna Teks
  static const Color textOnLight = Color(0xFF34495E); // Wet Asphalt (Abu-abu Gelap)
  static const Color textOnDark = Color(0xFFECF0F1); // Clouds (Abu-abu Terang)
  static const Color textOnPrimary = Colors.white;

  // Warna Utilitas
  static const Color success = Color(0xFF2ECC71); // Emerald (Hijau)
  static const Color error = Color(0xFFE74C3C);   // Alizarin (Merah)
  static const Color warning = Color(0xFFF1C40F);   // Sun Flower (Kuning)
  
  // Warna Aksen Tambahan (jika diperlukan)
  static const Color accentBlue = Color(0xFF3498DB); // Peter River Blue
}
