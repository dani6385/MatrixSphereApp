import 'package:flutter/material.dart';
// ignore: prefer_relative_imports
import 'package:shared_assets/shared_assets.dart'; // Sesuaikan import sesuai nama package kamu

class AppTheme extends StatelessWidget {
  /// Widget utama yang akan ditampilkan di dalam body Scaffold
  final Widget body;

  /// Menentukan apakah AppBar ditampilkan atau tidak
  final bool showAppBar;

  /// Warna latar belakang AppBar
  final Color appBarColor;

  const AppTheme({
    super.key,
    required this.body,
    this.showAppBar = true,
    // Menggunakan AppColors dari file shared_assets.dart
    this.appBarColor = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Opsional: set warna background global
      appBar: showAppBar
          ? AppBar(
              title: const Text("Title"),
              backgroundColor: appBarColor,
              foregroundColor: Colors.white,
            )
          : null,
      body: body,
    );
  }
}