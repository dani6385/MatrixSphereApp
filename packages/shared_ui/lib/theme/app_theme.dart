import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // Helper to check brightness from a BuildContext
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkCard,
      primaryColor: AppColors.primary,
      
      // Font global yang sama dengan HomeScreen
      textTheme: GoogleFonts.shareTechMonoTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(bodyMedium: GoogleFonts.shareTechMono(color: Colors.white)),
    );
  }
}

