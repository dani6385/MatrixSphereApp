import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AkunScreen extends StatelessWidget {
  const AkunScreen({super.key});

  // Mock user data – replace with real provider when available
  final Map<String, String> _userInfo = const {
    'Nama': 'Budi Santoso',
    'Email': 'budi.santoso@example.com',
    'Telepon': '+62 812 3456 7890',
    'Paket Aktif': 'Premium Wi‑Fi 100Mbps',
    'Status': 'Aktif',
    'Batas Akhir': '2026‑12‑31',
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun Saya', style: GoogleFonts.inter()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF212121), const Color(0xFF424242)]
                : [const Color(0xFFE3F2FD), const Color(0xFF90CAF9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _profileHeader(isDark),
                  const SizedBox(height: 24),
                  ..._userInfo.entries.map((e) => _infoTile(e.key, e.value, isDark)).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileHeader(bool isDark) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/profile_placeholder.png'),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 12),
          Text(_userInfo['Nama'] ?? 'User',
              style: GoogleFonts.oswald(fontSize: 26, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          const SizedBox(height: 4),
          Text(_userInfo['Email'] ?? '',
              style: GoogleFonts.openSans(fontSize: 14, color: isDark ? Colors.white70 : Colors.black54)),
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value, bool isDark) {
    return Card(
      color: isDark ? Colors.white10 : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: Icon(_iconForTitle(title), color: isDark ? Colors.tealAccent : Colors.indigo),
        title: Text(title, style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
        subtitle: Text(value, style: GoogleFonts.roboto()),
      ),
    );
  }

  IconData _iconForTitle(String title) {
    switch (title) {
      case 'Nama':
        return Icons.person;
      case 'Email':
        return Icons.email;
      case 'Telepon':
        return Icons.phone;
      case 'Paket Aktif':
        return Icons.card_membership;
      case 'Status':
        return Icons.check_circle;
      case 'Batas Akhir':
        return Icons.calendar_today;
      default:
        return Icons.info;
    }
  }
}
