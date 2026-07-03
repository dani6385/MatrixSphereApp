import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_ui/theme/app_theme.dart';

/// Halaman placeholder untuk menampilkan judul di tengah layar.
/// Berguna untuk rute yang belum memiliki UI lengkap.
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        backgroundColor: AppTheme.backgroundLight,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          title,
          style: GoogleFonts.dmSans(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
