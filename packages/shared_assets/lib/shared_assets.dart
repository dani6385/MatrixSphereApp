library shared_assets;

import 'package:flutter/material.dart'; // Wajib ada untuk tipe data Color

export 'src/app_theme.dart';
export 'src/theme_config.dart' hide AppTheme;


/// Kelas helper untuk menyimpan path aset agar tidak terjadi typo (salah ketik)
class AppAssets {
  // Path dasar untuk folder assets
  static const String _basePath = 'assets';

  // Contoh path gambar
  static const String logo = '$_basePath/images/logo.png';
  static const String background = '$_basePath/images/background.png';
  static const String userPlaceholder = '$_basePath/images/user_placeholder.png';

  // Contoh path ikon
  static const String iconSearch = '$_basePath/icons/search.svg';
  static const String iconUser = '$_basePath/icons/user.svg';

  // Nama package (Wajib digunakan di parameter `package` saat memanggil asset)
  static const String packageName = 'shared_assets';
}

/// Kelas helper untuk konfigurasi warna dan gaya teks global
class AppColors {
  static const int primaryValue = 0xFF2196F3;
  static const int secondaryValue = 0xFF03DAC6;

  // Mengubah tipe dari dynamic ke Color agar aplikasi stabil
  static const Color primaryColor = Color(primaryValue);
  static const Color secondaryColor = Color(secondaryValue);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFB00020);
}