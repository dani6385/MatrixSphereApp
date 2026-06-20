
import 'package:flutter/material.dart';

// For demonstration, a dummy class. In your real app, you'd import this from your services.
class HotspotActiveUser {
  final String user,
      uptime,
      bytesIn,
      bytesOut,
      limitBytesTotal,
      sessionTimeLeft,
      monthlyUsage,
      currentSpeed,
      macAddress,
      signalStrength,
      ssid;

  HotspotActiveUser({
    this.user = 'guest',
    this.uptime = '3h 45m 12s',
    this.bytesIn = '1.2 GB',
    this.bytesOut = '345.6 MB',
    this.limitBytesTotal = '10 GB',
    this.sessionTimeLeft = '20h 14m 48s',
    this.monthlyUsage = '15.8 GB',
    this.currentSpeed = '5.2 Mbps',
    this.macAddress = '00:1A:2B:3C:4D:5E',
    this.signalStrength = '-65 dBm',
    this.ssid = 'NetLink-Hotspot-2.4GHz',
  });

  String get totalBytesUsed {
    // In a real app, you would parse and calculate this properly.
    return '1.55 GB';
  }
}

class SeasonScreen extends StatelessWidget {
  const SeasonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, you would pass the HotspotActiveUser object from the previous screen.
    final HotspotActiveUser user = HotspotActiveUser(); // Using dummy data for UI layout.

    final Color primaryColor = const Color(0xFF0D1E40);
    final Color accentColor = const Color(0xFF2196F3);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text('Rincian Sesi',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildInfoCard(
            'Sesi Saat Ini',
            [
              _buildInfoTile('Pengguna', user.user, Icons.person),
              _buildInfoTile('Uptime', user.uptime, Icons.timer),
              _buildInfoTile('Sisa Waktu Sesi', user.sessionTimeLeft,
                  Icons.hourglass_bottom),
            ],
            accentColor,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Penggunaan Data',
            [
              _buildInfoTile(
                  'Diunduh (Bytes In)', user.bytesIn, Icons.download),
              _buildInfoTile(
                  'Diunggah (Bytes Out)', user.bytesOut, Icons.upload),
              _buildInfoTile(
                  'Total Digunakan', user.totalBytesUsed, Icons.data_usage),
              _buildInfoTile('Batas Data', user.limitBytesTotal, Icons.storage),
            ],
            accentColor,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Rincian Koneksi',
            [
              _buildInfoTile(
                  'Kecepatan Saat Ini', user.currentSpeed, Icons.speed),
              _buildInfoTile(
                  'Alamat MAC', user.macAddress, Icons.device_hub),
              _buildInfoTile('Kekuatan Sinyal', user.signalStrength,
                  Icons.signal_cellular_alt),
              _buildInfoTile(
                  'Terhubung ke (SSID)', user.ssid, Icons.wifi),
            ],
            accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> tiles, Color accentColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: accentColor,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            ...tiles,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String subtitle, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle,
          style: const TextStyle(fontSize: 16, color: Colors.black87)),
    );
  }
}
