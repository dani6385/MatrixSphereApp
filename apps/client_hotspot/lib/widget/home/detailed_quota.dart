import 'package:flutter/material.dart';

class DetailedQuotaPage extends StatelessWidget {
  const DetailedQuotaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kuota', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Detail Kuota Utama
            _buildDetailedCard(
              title: 'Paket Utama: Super Data 50GB',
              subtitle: 'Berlaku Hingga 15 November 2023',
              remaining: 36.2,
              total: 50.0,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            
            // Detail Kuota Malam
            _buildDetailedCard(
              title: 'Bonus Kuota Malam (00-06)',
              subtitle: 'Berlaku Hingga 1 Desember 2023',
              remaining: 9.1,
              total: 10.0,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),

            // Detail Kuota Aplikasi
            _buildAppUsageDetail(),
          ],
        ),
      ),
    );
  }

  // Widget untuk kartu detail
  Widget _buildDetailedCard({
    required String title,
    required String subtitle,
    required double remaining,
    required double total,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: remaining / total,
                    color: color,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(width: 10),
                Text('${((remaining / total) * 100).toInt()}%'),
              ],
            ),
            const SizedBox(height: 5),
            Text('${remaining.toStringAsFixed(1)} GB dari ${total.toStringAsFixed(0)} GB'),
          ],
        ),
      ),
    );
  }

  // Widget untuk rincian penggunaan per aplikasi
  Widget _buildAppUsageDetail() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Penggunaan Media Sosial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            _buildAppRow('Facebook', '1.2 GB', 0.8),
            _buildAppRow('Instagram', '1.3 GB', 0.6),
            _buildAppRow('WhatsApp', '0.5 GB', 0.2),
          ],
        ),
      ),
    );
  }

  Widget _buildAppRow(String appName, String usage, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(appName),
          Text('$usage ($usage digunakan)'),
        ],
      ),
    );
  }
}