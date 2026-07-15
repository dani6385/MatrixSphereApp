import 'package:flutter/material.dart';

// ==========================================================================
// == Definisi Tipografi Aplikasi ==
// ==========================================================================
// Berdasarkan skala tipe Material 3. Ini menyediakan satu sumber kebenaran
// untuk semua gaya teks di seluruh aplikasi.

// Catatan: Warna tidak didefinisikan di sini. ThemeData akan secara otomatis
// menerapkan warna yang benar (misalnya, kDarkTextPrimary) berdasarkan tema
// yang sedang aktif (terang atau gelap).

const kTextTheme = TextTheme(
  // ### Gaya Body (Teks isi)
  // Gaya utama untuk sebagian besar teks di aplikasi.
  bodyLarge: TextStyle(
    fontFamily: 'SystemDefault', // Menggunakan font sistem default
    fontWeight: FontWeight.w400, // Ini setara dengan FontWeight.Normal
    fontSize: 16.0,
    height: 1.5, // Kalkulasi dari lineHeight: 24sp / fontSize: 16sp
    letterSpacing: 0.5,
  ),
  // Digunakan untuk teks isi yang sedikit lebih kecil.
  bodyMedium: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  // Digunakan untuk teks keterangan atau catatan kecil.
  bodySmall: TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  ),

  // ### Gaya Judul (Headline & Title)
  // Judul terbesar, untuk teks yang sangat penting.
  displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.w400),
  // Judul halaman utama atau bagian penting.
  titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w400),
  // Judul sub-bagian, atau judul di dalam komponen seperti Card.
  titleMedium: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500, // Sedikit lebih tebal
    letterSpacing: 0.15,
  ),

  // ### Gaya Label
  // Digunakan di dalam tombol (Button) atau tab.
  labelLarge: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  ),
  // Teks yang lebih kecil, seperti keterangan di bawah field input.
  labelSmall: TextStyle(
    fontFamily: 'SystemDefault',
    fontWeight: FontWeight.w500, // Setara dengan FontWeight.Medium
    fontSize: 11.0,
    height: 1.45, // 16sp / 11sp
    letterSpacing: 0.5,
  ),
);
