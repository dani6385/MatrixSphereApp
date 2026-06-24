import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Model untuk menampung informasi perangkat.
class DeviceInfo {
  final String paket;
  final String ipAddress;
  final String macAddress;
  double tx; // Diubah menjadi double untuk pembaruan dinamis
  double rx; // Diubah menjadi double untuk pembaruan dinamis
  final String deviceModel;
  final String firmwareVersion;
  int uptimeSeconds; // Diubah menjadi int untuk pembaruan dinamis
  final String serialNumber;

  DeviceInfo({
    required this.paket,
    required this.ipAddress,
    required this.macAddress,
    required this.tx,
    required this.rx,
    required this.deviceModel,
    required this.firmwareVersion,
    required this.uptimeSeconds,
    required this.serialNumber,
  });
}

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  // Data awal perangkat, sekarang dalam bentuk objek.
  final DeviceInfo _deviceInfo = DeviceInfo(
    paket: 'Premium Wi‑Fi 100Mbps',
    ipAddress: '192.168.88.254',
    macAddress: '00:0C:29:E4:12:F1',
    tx: 2.4, // Mbps
    rx: 8.7, // Mbps
    deviceModel: 'Samsung Galaxy A22 5G',
    firmwareVersion: '12.11',
    uptimeSeconds: 263529, // 3 hari 1 jam 12 menit 9 detik
    serialNumber: 'SN-MXS-202412345',
  );

  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    _startDataSimulation();
  }

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
                  // Tombol Top-up
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement top-up functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.tealAccent : Colors.indigo,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Top Up',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Menampilkan data dari state
                  _infoCard('Paket', _deviceInfo.paket, isDark),
                  _infoCard('IP Address', _deviceInfo.ipAddress, isDark),
                  _infoCard('MAC Address', _deviceInfo.macAddress, isDark),
                  _infoCard(
                      'TX (Upload)',
                      '${_deviceInfo.tx.toStringAsFixed(1)} Mbps',
                      isDark),
                  _infoCard(
                      'RX (Download)',
                      '${_deviceInfo.rx.toStringAsFixed(1)} Mbps',
                      isDark),
                  _infoCard('Device Model', _deviceInfo.deviceModel, isDark),
                  _infoCard('Firmware Version', _deviceInfo.firmwareVersion, isDark),
                  _infoCard('Uptime', _formatUptime(_deviceInfo.uptimeSeconds), isDark),
                  _infoCard('Serial Number', _deviceInfo.serialNumber, isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _statusTimer?.cancel(); // Hentikan timer saat widget tidak lagi digunakan
    super.dispose();
  }

  // --- LOGIKA SIMULASI DATA ---

  void _startDataSimulation() {
    _statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      setState(() {
        // Perbarui uptime setiap detik
        _deviceInfo.uptimeSeconds++;

        // Simulasikan fluktuasi traffic (mirip di home_screen)
        _deviceInfo.tx = math.max(
            0.1, 2.5 + 1.5 * math.sin(DateTime.now().millisecondsSinceEpoch / 2000));
        _deviceInfo.rx = math.max(
            0.2, 9.0 + 5.0 * math.cos(DateTime.now().millisecondsSinceEpoch / 2500));
      });
    });
  }

  String _formatUptime(int totalSeconds) {
    int days = totalSeconds ~/ (24 * 3600);
    int hours = (totalSeconds % (24 * 3600)) ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    String daysStr = days > 0 ? '${days}d ' : '';
    return '$daysStr${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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
      case 'Paket':
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
