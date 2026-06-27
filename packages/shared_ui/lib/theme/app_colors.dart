import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const backgroundColor = Colors.transparent;
  static Color color(bool isDark) =>
      isDark ? const Color(0xFF1E293B) : Colors.white;
  static const lightBackground = Color(0xFFF8FAFC);
  static const lightCard = Colors.white;
  static const lightText = Color(0xFF1E293B);

  // Dark Theme Colors (Sesuai `home_screen.dart` Anda)
  static const darkBackground = Color(0xFF0F172A);
  static const darkCard = Color(0xFF1E293B);
  static const darkText = Colors.white;

  static const primary = Color(0xFF4F46E5);
  static const progressSpeed = Colors.tealAccent;
  static const progressPull = Colors.purpleAccent;
  static const boxShadow = Color.fromARGB(5, 0, 0, 0);

  static const Color text = Colors.white;
  static const Color subText = Color(0xFF64748B);
}
