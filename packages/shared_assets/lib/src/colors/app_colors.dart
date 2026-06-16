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
  static const Color backgroundColor = Color(0xFFF0E5F8); // Ungu muda dari login screen

  // Warna untuk permukaan seperti Card, Dialog, BottomSheet.
  static const Color surfaceColor = Colors.white;

  // Warna untuk menampilkan pesan error.
  static const Color errorColor = Color(0xFFB00020);
}
