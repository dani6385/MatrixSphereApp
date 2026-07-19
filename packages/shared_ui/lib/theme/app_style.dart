import 'package:flutter/material.dart';
import 'package:shared_ui/theme/app_colors.dart';

class AppStyles {
  // Dekorasi untuk kartu utama
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: kDarkSecondary,
    borderRadius: BorderRadius.circular(12),
  );

  // Dekorasi untuk container bagian dalam (jam dan tanggal)
  static final BoxDecoration innerCardDecoration = BoxDecoration(
    color: kDarkBackground,
    borderRadius: BorderRadius.circular(8),
  );

  // Gaya untuk OutlinedButton
  static final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: kDarkTextPrimary,
    side: const BorderSide(color: kDarkTextSecondary),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Gaya untuk TextButton di AppBar
  static final ButtonStyle appBarTextButtonStyle = TextButton.styleFrom(
    foregroundColor: kDarkTextPrimary,
    backgroundColor: kDarkSecondary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  // Metode untuk mendapatkan gaya teks, bergantung pada TextTheme

  // Untuk header kecil seperti 'Karyawan Aktif'
  static TextStyle cardHeader(TextTheme textTheme) =>
      textTheme.bodySmall!.copyWith(color: kDarkTextSecondary);

  // Untuk judul utama seperti 'Matrix Admin'
  static TextStyle primaryTitle(TextTheme textTheme) =>
      textTheme.titleMedium!.copyWith(color: kDarkTextPrimary);

  // Untuk subjudul sekunder seperti ID karyawan
  static TextStyle secondarySubtitle(TextTheme textTheme) =>
      textTheme.bodySmall!.copyWith(color: kDarkTextSecondary);

  // Untuk tampilan jam yang besar
  static TextStyle timeDisplay(TextTheme textTheme) => textTheme.displaySmall!
      .copyWith(color: kDarkTextPrimary, fontWeight: FontWeight.bold);

  // Untuk tampilan tanggal di bawah jam
  static TextStyle dateDisplay(TextTheme textTheme) =>
      textTheme.bodyMedium!.copyWith(color: kDarkTextSecondary);
}
