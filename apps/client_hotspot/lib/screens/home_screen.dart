import 'package:flutter/material.dart';
import 'widgets/mading_section.dart';
import 'widgets/status_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  // Variabel untuk menyimpan data dari MikroTik
  String _sisaKuota = "24.7 GB";
  String _masaAktif = "21 Hari";
  String _uptime = "3h 45m";
  String _totalUsage = "25.3 GB";
  String _currentSpeed = "50/10 Mbps"; // Format: Download/Upload
  double _persenKuota = 0.75; // Contoh 75%

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF0D1E40); // Deep Sapphire
    final Color accentColor = const Color(0xFF2196F3); // Modern Blue
    final Color cardColor = Colors.white;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA), // Light Gray Background
      appBar: AppBar(
        title: const Text(
          'NetLink Hotspot',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu Status Utama (yang sudah ada)
            StatusCard(
              sisaKuota: _sisaKuota,
              persenKuota: _persenKuota,
              masaAktif: _masaAktif,
              uptime: _uptime,
              totalUsage: _totalUsage,
              currentSpeed: _currentSpeed,
              primaryColor: primaryColor,
              accentColor: accentColor,
              cardColor: cardColor,
            ),
            const SizedBox(height: 24),

            // BAGIAN BARU: Tiga Kartu Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.timer_sharp,
                    color: Colors.orange,
                    title: 'Uptime',
                    subtitle: '(Session)',
                    value: _uptime,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.download_for_offline_outlined,
                    color: Colors.blue,
                    title: 'Total Usage',
                    subtitle: '(Month)',
                    value: _totalUsage,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.speed_outlined,
                    color: Colors.green,
                    title: 'Current Speed',
                    subtitle: '',
                    value: _currentSpeed.replaceFirst('/', ' Mbps /\n'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Mading Informasi (yang sudah ada)
            Text(
              'Mading Informasi & Promo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            MadingSection(cardColor: cardColor, accentColor: accentColor),
            const SizedBox(height: 16),

            // Iklan (yang sudah ada)
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Text(
                  "IKLAN SPONSOR - Promo Kopi Lokal (AdMob)",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk membuat kartu info kecil
  Widget _buildInfoCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
