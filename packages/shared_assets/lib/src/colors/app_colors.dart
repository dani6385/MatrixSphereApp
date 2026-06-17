import 'package:flutter/material.dart';

/// Berisi definisi warna yang digunakan secara konsisten di seluruh aplikasi.
/// Memusatkan warna di sini memudahkan untuk mengubah tema visual aplikasi
/// di satu tempat.
class AppColors {
  // Warna utama yang digunakan untuk branding, tombol utama, app bar, dll.
  static const Color primaryColor = Color(0xFF6200EE); // Ungu yang kuat

  // Warna sekunder untuk aksen, floating action button, dll.
  static const Color secondaryColor = Color(0xFF03DAC6); // Teal

  // Warna latar belakang utama untuk sebagian besar layar.
  static const Color backgroundColor =
      Color.fromARGB(155, 64, 71, 134); // Ungu muda dari login screen
  static const Color foregroundColor = Color.fromARGB(255, 126, 92, 92);
  static const Color wifiColor = Colors.blueAccent;
  // Warna untuk permukaan seperti Card, Dialog, BottomSheet.
  static const Color surfaceColor = Colors.white;
  static const Color textColor = Colors.black87;
  static const Color textSecondaryColor = Colors.white;
  // Warna untuk menampilkan pesan error.
  static const Color errorColor = Color(0xFFB00020);
  static const Color voucherColor = Color(0xFF3498DB); // Biru voucher
  static const Color memberColor = Color(0xFF2ECC71); // Hijau member
  static const Color scanQrColor = Color(0xFFF1C40F);
  static const Color payQrColor = Color(0x00e74c3c);
  static const Color trialColor = Color(0xFF9B59B6); // Ungu trial
}
