import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('NetLink Hotspot', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1A237E), // Warna biru gelap profesional
        elevation: 0,
        actions: const [
          Icon(Icons.notifications_none),
          Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Icon(Icons.person)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kartu Kuota Utama
            _buildMainQuotaCard(),
            const SizedBox(height: 20),
            
            // Grid Status (Uptime, Usage, Speed)
            Row(
              children: [
                _buildSmallStatusCard("Uptime", "3h 45m", Icons.timer, Colors.orange),
                const SizedBox(width: 10),
                _buildSmallStatusCard("Usage", "25.3 GB", Icons.download, Colors.blue),
                const SizedBox(width: 10),
                _buildSmallStatusCard("Speed", "50/10 Mbps", Icons.speed, Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            
            // Mading Informasi
            const Text("Mading Informasi & Promo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildPromoItem("Promo Paket Hebat!", "Hemat 30% Bulan Ini", Icons.info_outline),
            _buildPromoItem("Jaringan Stabil", "Semua Sistem OK", Icons.check_circle_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildMainQuotaCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10)]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("SISA KUOTA", style: TextStyle(color: Colors.grey)), Text("24.7 GB", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))]),
              SizedBox(width: 50, height: 50, child: CircularProgressIndicator(value: 0.7, strokeWidth: 8, color: Colors.blue)),
            ],
          ),
          const Divider(height: 30),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            IconText(icon: Icons.calendar_today, text: "21 Hari"),
            IconText(icon: Icons.access_time, text: "3h 45m"),
          ])
        ],
      ),
    );
  }

  Widget _buildSmallStatusCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(children: [Icon(icon, color: color), Text(title, style: const TextStyle(fontSize: 12)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))]),
      ),
    );
  }

  Widget _buildPromoItem(String title, String sub, IconData icon) {
    return Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: ListTile(leading: Icon(icon, color: Colors.blue), title: Text(title), subtitle: Text(sub), trailing: const Icon(Icons.chevron_right)));
  }
}

class IconText extends StatelessWidget {
  final IconData icon; final String text;
  const IconText({super.key, required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, size: 16, color: Colors.blue), const SizedBox(width: 5), Text(text)]);
}