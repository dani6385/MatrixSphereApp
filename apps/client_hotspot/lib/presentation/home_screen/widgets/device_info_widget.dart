import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/device_provider.dart';


class DeviceInfoWidget extends StatelessWidget {
  const DeviceInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk rebuild widget ini saat ada notifikasi dari provider
    return Consumer<DeviceProvider>(
      builder: (context, provider, child) {
        // Tampilkan loading indicator saat data sedang diambil
        if (provider.isLoading) {
          return const Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              height: 150,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // Tampilkan pesan error jika ada
        if (provider.errorMessage != null) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text(provider.errorMessage!)),
            ),
          );
        }

        // Jika data tidak ada (kasus yang jarang terjadi)
        if (provider.deviceInfo == null) {
          return const SizedBox.shrink();
        }

        final deviceInfo = provider.deviceInfo!;

        // Helper untuk memformat durasi uptime
        String formatUptime(int totalSeconds) {
          final duration = Duration(seconds: totalSeconds);
          final days = duration.inDays;
          final hours = duration.inHours % 24;
          final minutes = duration.inMinutes % 60;
          final seconds = duration.inSeconds % 60;
          return '${days}d ${hours}h ${minutes}m ${seconds}s';
        }

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Perangkat',
                  style: GoogleFonts.dmSans(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Model', deviceInfo.deviceModel),
                _buildInfoRow('Versi OS', deviceInfo.osVersion),
                _buildInfoRow('Versi Aplikasi', deviceInfo.appVersion),
                _buildInfoRow('Alamat IP', deviceInfo.ipAddress),
                _buildInfoRow('Serial', deviceInfo.serialNumber),
                _buildInfoRow('Uptime', formatUptime(deviceInfo.uptimeSeconds)),
                const Divider(height: 24),
                _buildTrafficRow(
                    'Upload', deviceInfo.tx, Icons.arrow_upward, Colors.blue),
                _buildTrafficRow('Download', deviceInfo.rx,
                    Icons.arrow_downward, Colors.green),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTrafficRow(
      String label, double value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(
            '${value.toStringAsFixed(2)} Mbps',
            style: TextStyle(fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
    );
  }
}