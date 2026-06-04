// packages/service_shared/lib/src/utils/app_constants.dart

import 'dart:ui';

abstract class AppConstants {
  // Gunakan abstract agar class tidak bisa di-instansiasi
  
  static const String appName = "MatrixSphere";

  // Ukuran standar
  static const double defaultPadding = 16.0;

  // Key untuk Local Storage
  static const String sessionKey = "SESSION_ID";
}

class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 12.0;
}

class AppColors {
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color accentColor = Color(0xFF03DAC6);
  static const Color errorColor = Color(0xFFB00020);
}

class AppConfig {
  static const String appName = "MatrixSphere";
  static const String appVersion = "1.0.0";
  static const int timeoutDuration = 30; // dalam detik
}

class AppStrings {
  static const String loginTitle = "Selamat Datang";
  static const String genericError = "Terjadi kesalahan, silakan coba lagi.";
  static const String emptyData = "Data tidak ditemukan.";
}

class StorageKeys {
  static const String authToken = "auth_token";
  static const String isDarkMode = "is_dark_mode";
  static const String userPreferences = "user_prefs";
}

