import 'package:flutter/material.dart';

// Dummy data class for demonstration
class SpeedDetails {
  final double downloadSpeed; // in Mbps
  final double uploadSpeed;   // in Mbps
  final int ping;             // in ms
  final String serverLocation;

  SpeedDetails({
    this.downloadSpeed = 48.2,
    this.uploadSpeed = 9.8,
    this.ping = 24,
    this.serverLocation = 'Jakarta, ID',
  });
}

class CurrentSpeedScreen extends StatelessWidget {
  const CurrentSpeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SpeedDetails speedDetails = SpeedDetails(); // Using dummy data
    final Color primaryColor = const Color(0xFF0D1E40);
    final Color accentColor = const Color(0xFF2196F3);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),
      appBar: AppBar(
        title: const Text('Rincian Kecepatan Saat Ini', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildSpeedometerCard(speedDetails, accentColor, primaryColor),
            const SizedBox(height: 24),
            _buildConnectionDetailsCard(speedDetails, primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedometerCard(SpeedDetails details, Color accentColor, Color primaryColor) {
    // Max speed for the gauge, e.g., 100 Mbps
    const double maxSpeed = 100.0;
    final double downloadPercentage = (details.downloadSpeed / maxSpeed).clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background track
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
                    ),
                  ),
                  // Speed indicator
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: downloadPercentage,
                      strokeWidth: 12,
                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    ),
                  ),
                  // Center text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        details.downloadSpeed.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      const Text(
                        'Mbps',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSpeedDetail(
                  'Download', 
                  details.downloadSpeed,
                  Icons.arrow_downward_rounded,
                  accentColor,
                ),
                _buildSpeedDetail(
                  'Upload', 
                  details.uploadSpeed,
                  Icons.arrow_upward_rounded,
                  Colors.green.shade600,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedDetail(String label, double speed, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          '${speed.toStringAsFixed(1)} Mbps',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildConnectionDetailsCard(SpeedDetails details, Color primaryColor) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.network_ping_rounded, color: primaryColor),
            title: const Text('Ping'),
            trailing: Text('${details.ping} ms', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: Icon(Icons.location_on_outlined, color: primaryColor),
            title: const Text('Server'),
            trailing: Text(details.serverLocation, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
