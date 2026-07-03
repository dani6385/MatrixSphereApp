import 'package:flutter/material.dart';

/// Model data untuk merepresentasikan satu item dalam CustomBottomNavBar.
class BottomNavItem {
  /// Ikon yang akan ditampilkan.
  final IconData icon;

  /// Label teks yang muncul di bawah ikon.
  final String label;

  /// Path rute GoRouter yang akan dinavigasi saat item ditekan.
  final String routePath;

  const BottomNavItem({
    required this.icon,
    required this.label,
    required this.routePath,
  });
}
