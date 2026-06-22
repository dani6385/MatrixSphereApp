import 'package:flutter/material.dart';

class DetailedQuotaPage extends StatelessWidget {
  final double totalMainQuotaGB;
  final double remainingMainQuotaGB;
  final double totalBonusMalamGB;
  final double remainingBonusMalamGB;

  const DetailedQuotaPage({
    super.key,
    required this.totalMainQuotaGB,
    required this.remainingMainQuotaGB,
    required this.totalBonusMalamGB,
    required this.remainingBonusMalamGB,
  });

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
            _buildDetailedCard(
              title: 'Paket Utama: Super Data 50GB',
              subtitle: 'Berlaku Hingga 15 November 2023',
              remaining: remainingMainQuotaGB,
              total: totalMainQuotaGB,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildDetailedCard(
              title: 'Bonus Kuota Malam (00-06)',
              subtitle: 'Berlaku Hingga 1 Desember 2023',
              remaining: remainingBonusMalamGB,
              total: totalBonusMalamGB,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            _buildAppUsageDetail(),
          ],
        ),
      ),
    );
  }

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
            _buildAppRow('Facebook', 1.2, 2.0, 0.6, Colors.blue),
            _buildAppRow('Instagram', 1.3, 2.0, 0.65, Colors.pink),
            _buildAppRow('WhatsApp', 0.5, 1.0, 0.5, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildAppRow(String appName, double used, double total, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(appName, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('$used GB / $total GB'),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: percent,
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }
}
