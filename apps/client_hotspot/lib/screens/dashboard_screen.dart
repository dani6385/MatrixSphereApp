import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Widget ini sekarang hanya mengembalikan kontennya saja,
    // tanpa Scaffold atau AppBar.
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2, // 2 kolom
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          _buildMenuCard(Icons.person_add, 'Beli Voucher', Colors.orange),
          _buildMenuCard(Icons.wifi_tethering, 'Layanan Hotspot', Colors.blue),
          _buildMenuCard(Icons.history, 'Riwayat Transaksi', Colors.green),
          _buildMenuCard(Icons.account_circle, 'Profil Saya', Colors.purple),
        ],
      ),
    );
  }

  // Widget pembantu untuk membuat kotak menu
  Widget _buildMenuCard(IconData icon, String title, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          // Aksi ketika menu di-tap
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
