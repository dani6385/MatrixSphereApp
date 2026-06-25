import 'dart:ui';
import '../providers/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);
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
            // Tampilkan indikator loading atau pesan error jika perlu
            child: deviceProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : deviceProvider.errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Error: ${deviceProvider.errorMessage}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      )
                    : _buildStatusContent(context, deviceProvider.deviceInfo!, isDark),
          ),
        ),
      ),
    );
  }

  // Memisahkan konten utama ke dalam widget baru
  Widget _buildStatusContent(BuildContext context, DeviceInfo deviceInfo, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 24),
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
          //_infoCard('Paket', deviceInfo.paket, isDark),
          _infoCard('IP Address', deviceInfo.ipAddress, isDark),
          //_infoCard('MAC Address', deviceInfo.macAddress, isDark),
          _infoCard('TX (Upload)', '${deviceInfo.tx.toStringAsFixed(1)} Mbps', isDark),
          _infoCard('RX (Download)', '${deviceInfo.rx.toStringAsFixed(1)} Mbps', isDark),
          _infoCard('Device Model', deviceInfo.deviceModel, isDark),
          _infoCard('OS Version', deviceInfo.osVersion, isDark),
          _infoCard('Uptime', _formatUptime(deviceInfo.uptimeSeconds), isDark),
          //_infoCard('Serial Number', deviceInfo.serialNumber, isDark),
        ],
      ),
    );
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
      case 'OS Version':
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
