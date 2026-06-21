import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Status Sistem', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildStatusItem('Koneksi Internet', 'Stabil', Icons.wifi, Colors.green),
            _buildStatusItem('Perangkat Terhubung', '12 User', Icons.people_alt, Colors.blue),
            _buildStatusItem('Suhu Sistem', '45°C', Icons.thermostat, Colors.orange),
            _buildStatusItem('Keamanan', 'Terlindungi', Icons.security, Colors.green),
          ],
        ),
      ),
    );
  }

  // Widget helper untuk membuat baris status yang profesional
  Widget _buildStatusItem(String title, String status, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(
          status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}