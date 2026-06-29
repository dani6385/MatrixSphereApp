import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const backgroundColor = Color.fromARGB(0, 122, 122, 122);
  static List<Color> color(bool isDark) => isDark
      ? [const Color(0xFF212121), const Color(0xFF424242)]
      : [const Color(0xFFE3F2FD), const Color(0xFF90CAF9)];
  static List<Color> selectionColors(bool isSelected) => isSelected
      ? [const Color(0xFF00897B), const Color(0xFF424242)]
      : [const Color(0xFFE3F2FD), const Color(0xFF90CAF9)];
  
  static const transparent = Colors.transparent;
  static const lightBackground = Color(0xFFF8FAFC);
  static const lightCard = Colors.white;
  static const lightText = Color(0xFF1E293B);

  // Dark Theme Colors (Sesuai `home_screen.dart` Anda)
  static const darkBackground = Color(0xFF0F172A);
  static const darkCard = Color(0xFF1E293B);
  static const darkText = Colors.white;

  static const primary = Color(0xFF00897B);
  static const progressSpeed = Colors.tealAccent;
  static const progressPull = Colors.purpleAccent;
  static const boxShadow = Color.fromARGB(5, 0, 0, 0);

  static const Color text = Colors.white;
  static const Color subText = Color(0xFF64748B);
}
