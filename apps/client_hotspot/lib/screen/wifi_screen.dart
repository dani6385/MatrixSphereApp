import 'package:flutter/material.dart';

class WifiScreen extends StatelessWidget {
  const WifiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Wi-Fi Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Connected Network
            const Text("Terhubung ke:", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            _buildConnectedCard(),
            const SizedBox(height: 30),
            
            // Available Networks
            const Text("Jaringan Tersedia", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                children: [
                  _buildNetworkItem("Office_Guest", "Terenkripsi", Icons.wifi_2_bar, false),
                  _buildNetworkItem("Home_Network", "Tersimpan", Icons.wifi, true),
                  _buildNetworkItem("Cafe_Public", "Terbuka", Icons.wifi_1_bar, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.wifi, color: Colors.white, size: 40),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Matrix_WiFi_Pro", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Terhubung - 5GHz", style: TextStyle(color: Colors.white70)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNetworkItem(String name, String type, IconData icon, bool isConnected) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: isConnected ? Colors.deepPurple : Colors.grey),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(type),
        trailing: isConnected ? const Icon(Icons.check_circle, color: Colors.deepPurple) : null,
      ),
    );
  }
}