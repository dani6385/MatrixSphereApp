import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  // Mock data – replace with real services when available
  final Map<String, String> _deviceInfo = const {
    'Paket': 'Premium Wi‑Fi 100Mbps',
    'IP Address': '192.168.0.45',
    'MAC Address': 'AA:BB:CC:DD:EE:FF',
    'TX (Upload)': '25 Mbps',
    'RX (Download)': '95 Mbps',
    'Device Model': 'Samsung Galaxy a22 5G',
    'Firmware Version': '12.11',
    'Uptime': '3 days 04:12:09',
    'Serial Number': 'nomber transaksi',
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Perangkat', style: GoogleFonts.inter()),
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
                  _buildHeader(isDark),
                  const SizedBox(height: 24),
                  ..._deviceInfo.entries
                      .map((e) => _infoCard(e.key, e.value, isDark))
                      .toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.router,
            size: 80,
            color: isDark ? Colors.tealAccent : Colors.indigo,
          ),
          const SizedBox(height: 12),
          Text(
            'MikroTik Dashboard',
            style: GoogleFonts.oswald(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Informasi detail perangkat Anda',
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, String value, bool isDark) {
    return Card(
      color: isDark ? Colors.white10 : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(value, style: GoogleFonts.roboto()),
        leading: Icon(
          _iconForTitle(title),
          color: isDark ? Colors.tealAccent : Colors.indigo,
        ),
      ),
    );
  }

  IconData _iconForTitle(String title) {
    switch (title) {
      case 'Paket yang Dibeli':
        return Icons.card_membership;
      case 'IP Address':
        return Icons.wifi;
      case 'MAC Address':
        return Icons.lan;
      case 'TX (Upload)':
        return Icons.upload;
      case 'RX (Download)':
        return Icons.download;
      case 'Device Model':
        return Icons.devices;
      case 'Firmware Version':
        return Icons.system_update;
      case 'Uptime':
        return Icons.timer;
      case 'Serial Number':
        return Icons.confirmation_number;
      default:
        return Icons.info;
    }
  }
}
