import 'package:flutter/material.dart';

class SessionDetails {
  final String uptime;
  final String startTime;
  final String ipAddress;
  final String macAddress;
  final String device;

  SessionDetails({
    this.uptime = '3h 45m 12s',
    this.startTime = '14:30:05',
    this.ipAddress = '192.168.88.254',
    this.macAddress = 'A0:B1:C2:D3:E4:F5',
    this.device = 'Android (User-Agent)',
  });
}

class SeasonScreen extends StatelessWidget {
  const SeasonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SessionDetails data = SessionDetails();
    final Color primaryColor = const Color(0xFF0D1E40);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFFF4F7FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildUptimeCard(data.uptime, primaryColor),
            const SizedBox(height: 20),
            _buildDetailsList(data),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.power_settings_new, color: Colors.white),
              label: const Text('Disconnect Session', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Logic to disconnect the session
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Disconnecting...')),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildUptimeCard(String uptime, Color textColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            children: [
              const Text(
                'CURRENT SESSION UPTIME',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                uptime,
                style: TextStyle(
                  color: textColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsList(SessionDetails data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildDetailRow(Icons.play_circle_fill_outlined, 'Start Time', data.startTime),
          const Divider(height: 1),
          _buildDetailRow(Icons.wifi_tethering, 'IP Address', data.ipAddress),
          const Divider(height: 1),
          _buildDetailRow(Icons.perm_identity, 'MAC Address', data.macAddress),
          const Divider(height: 1),
          _buildDetailRow(Icons.smartphone, 'Device', data.device),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Text(value, style: const TextStyle(fontSize: 15, color: Color(0xFF0D1E40))),
    );
  }
}
