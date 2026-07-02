
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightCard = Colors.white;
  static const Color lightText = Color(0xFF1E293B);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkText = Colors.white;

  // Shared Colors
  static const Color primary = Color(0xFF00897B);
  static const Color secondary = Color(0xFFFF8F00);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFFA000);

  // Status Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color info = Color(0xFF0288D1);

  // Other Colors
  static const Color progressSpeed = Colors.tealAccent;
  static const Color progressPull = Colors.purpleAccent;
  static const Color boxShadow = Color.fromARGB(5, 0, 0, 0);

  static const Color text = Colors.white;
  static const Color subText = Color(0xFF64748B);

  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color cardLight = Colors.white;

  /// Tema untuk mode terang (light mode)
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    primaryColor: primary,
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
    ),
  );

  /// Tema untuk mode gelap (dark mode)
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: primary,
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
      surface: darkBackground,
    ),
  );
}
