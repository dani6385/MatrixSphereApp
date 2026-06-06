import 'package:flutter/material.dart';

class AppTheme {
  // Definisi Font
  static const String primaryFont = 'Poppins'; // Pastikan font sudah terdaftar di pubspec.yaml

  // Definisi Ukuran Tombol
  static const double buttonHeight = 50.0;
  static const double buttonRadius = 12.0;
  static const TextStyle buttonTextStyle = TextStyle(
    fontFamily: primaryFont,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );
}