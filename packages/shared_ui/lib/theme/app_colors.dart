// lib/theme/app_colors.dart (atau sesuaikan dengan path projekmu)

import 'package:flutter/material.dart';

/// Palet Warna Profesional & Modern (Berbasis Design Token)
class AppColors {
  // ==========================================
  // 1. WARNA MEREK UTAMA (Brand Identity)
  // ==========================================
  static const Color primary = Color(0xFF6366F1);     // Indigo-500 (Modern & Elegan)
  static const Color secondary = Color(0xFF3B82F6);   // Blue-500
  static const Color tertiary = Color(0xFF14B8A6);    // Teal-500
  static const Color accent = Color(0xFF8B5CF6);      // Purple-500

  // ==========================================
  // 2. TEMA GELAP (Professional Dark Mode)
  // ==========================================
  static const Color darkBackground = Color(0xFF0B0E14); // Deep slate black (Anti-silau)
  static const Color darkSurface = Color(0xFF111622);    // Kartu, Dialog, App Bar
  static const Color darkAppBar = Color(0xFF111622);     // Konsisten dengan surface
  static const Color darkBorder = Color(0xFF1E293B);     // Garis batas / Divider halus
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // Teks utama putih bersih
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Teks abu-abu senada

  // ==========================================
  // 3. TEMA TERANG (Clean Light Mode)
  // ==========================================
  static const Color lightBackground = Color(0xFFF8FAFC); // Ice white yang bersih
  static const Color lightSurface = Color(0xFFFFFFFF);    // Kartu, Dialog, App Bar
  static const Color lightAppBar = Color(0xFFFFFFFF);     // Putih bersih
  static const Color lightBorder = Color(0xFFE2E8F0);     // Garis batas / Divider halus
  static const Color lightTextPrimary = Color(0xFF0F172A); // Dark slate (kontras tinggi)
  static const Color lightTextSecondary = Color(0xFF475569); // Charcoal sekunder

  // ==========================================
  // 4. WARNA STATUS & UMPAN BALIK (Feedback)
  // ==========================================
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color warning = Color(0xFFF59E0B); // Amber / Orange
  static const Color error = Color(0xFFEF4444);   // Red / Danger
  static const Color info = Color(0xFF0EA5E9);    // Sky Blue

  // ==========================================
  // 5. WARNA UTILITAS
  // ==========================================
  static const Color transparent = Colors.transparent;
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
}

// ==========================================
  // 1. WARNA MEREK UTAMA (Brand Identity)
  // ==========================================
const Color kBrandPrimary = AppColors.primary;
const Color kBrandSecondary = AppColors.secondary;
const Color kBrandTertiary = AppColors.tertiary;
const Color kAccent = AppColors.accent;  

// ==========================================
  // 2. TEMA GELAP (Professional Dark Mode)
  // ==========================================
const Color kDarkBackground = AppColors.darkBackground;
const Color kDarkSurface = AppColors.darkSurface;
const Color kDarkAppBar = AppColors.darkAppBar;
const Color kDarkBorder = AppColors.darkBorder;
const Color kDarkTextPrimary = AppColors.darkTextPrimary;
const Color kDarkTextSecondary = AppColors.darkTextSecondary;
// ==========================================
// 3. TEMA TERANG (Clean Light Mode)
// ==========================================
const Color kLightBackground = AppColors.lightBackground;
const Color kLightSurface = AppColors.lightSurface;
const Color kLightAppBar = AppColors.lightAppBar;
const Color kLightBorder = AppColors.lightBorder;
const Color kLightTextPrimary = AppColors.lightTextPrimary;
const Color kLightTextSecondary = AppColors.lightTextSecondary;
// ==========================================
// 4. WARNA STATUS & UMPAN BALIK (Feedback)
// ==========================================
const Color kSuccess = AppColors.success;
const Color Kwarning = AppColors.warning;
const Color kError = AppColors.error;
const Color kInfo = AppColors.info;



// Sisa alias lama pendukung
const Color darkBlueBackground = Color(0xFF0D1B2A);
const Color kBlueSecondary = kBrandSecondary;
const Color kCyanPrimary = kBrandPrimary;
const Color kSlateBackgroundDark = kDarkBackground;
const Color kSlateBackgroundLight = kLightBackground;
const Color kSlateBorderDark = kDarkBorder;
const Color kSlateBorderLight = kLightBorder;
const Color kSlateSurfaceDark = kDarkSurface;
const Color kSlateSurfaceLight = kLightSurface;
const Color kTealTertiary = kBrandTertiary;
const Color kTextOnDarkPrimary = kDarkTextPrimary;
const Color kTextOnDarkSecondary = kDarkTextSecondary;
const Color kTextOnLightPrimary = kLightTextPrimary;
const Color kTextOnLightSecondary = kLightTextSecondary;

const Color kAccentBlue = Color(0xFF2979FF);
const Color kAccentPurple = Color(0xFF7C4DFF);
const Color kAlertRed = AppColors.error;
const Color kBrandBlack = Color(0xFF2D3238);
const Color kBrandWhite = Color(0xFFFFFFFF);
const Color kDarkOutline = Color(0xFF475569);
const Color kDarkSecondary = Colors.black12;
const Color kElectricBlue = Color(0xFF2E5BFF);
const Color kInfoColor = AppColors.info;
const Color kNeonBlue = Color(0xFF007AFF);
const Color kNeonCyan = Color(0xFF00E5FF);
const Color kPurple = Color(0xFF6A5AE0);
const Color kRadiantRose = Color(0xFFE91E63);
const Color kSeaGreen = Color(0xFF2E8B57);
const Color kSoftTeal = Color(0xFF388E3C);
const Color kTransparent = Colors.transparent;
const Color kVividOrchid = Color(0xFFD000C8);
const Color kWarmOrange = Color(0xFFF57C00);
const Color kDarkDivider = Color(0xFF24292E);
const Color kSemanticError = AppColors.error;
const Color kSemanticSuccess = AppColors.success;