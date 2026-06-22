import 'package:flutter/material.dart';
import '../models/quota_model.dart';

class DetailQuotaScreen extends StatelessWidget {
  final Map<String, dynamic> quotaData;

  const DetailQuotaScreen({super.key, required this.quotaData});

  @override
  Widget build(BuildContext context) {
    // --- KONVERSI KE MODEL DI SINI ---
    // Ubah data Map mentah menjadi objek Quota yang bersih.
    final mainQuota = Quota.fromMap(Map<String, dynamic>.from(quotaData['main_quota'] ?? {}));
    final bonusQuota = Quota.fromMap(Map<String, dynamic>.from(quotaData['bonus_quota'] ?? {}));
    
    // (Untuk social quota, kita akan buat modelnya nanti jika diperlukan)
    final socialQuotas = (quotaData['social_media_quota'] as List? ?? []).cast<Map<String, dynamic>>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Detail Kuota', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Kirim objek Quota ke widget, bukan Map
          _buildMainQuotaCard(mainQuota),
          const SizedBox(height: 16),
          _buildBonusQuotaCard(bonusQuota),
          const SizedBox(height: 16),
          _buildSocialQuotaCard(socialQuotas),
        ],
      ),
    );
  }

  // --- REFACTOR: Widget sekarang menerima objek Quota ---
  Widget _buildMainQuotaCard(Quota quota) {
    return Card(
      elevation: 2,
      shadowColor: Colors.deepPurple.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Akses data langsung dari model
            Text(quota.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text('Berlaku hingga ${quota.validUntil}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              // Gunakan getter dari model
              value: quota.persentaseSisa,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${quota.sisa.toStringAsFixed(1)} GB dari ${quota.total.toStringAsFixed(0)} GB', style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  // Gunakan getter dari model
                  '${quota.persentaseSisaInt}%',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  // --- REFACTOR: Widget sekarang menerima objek Quota ---
  Widget _buildBonusQuotaCard(Quota quota) {
    return Card(
      elevation: 2,
      shadowColor: Colors.deepPurple.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(quota.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            Text('Berlaku hingga ${quota.validUntil}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: quota.persentaseSisa,
              backgroundColor: Colors.grey[300],
              color: Colors.orange,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${quota.sisa.toStringAsFixed(1)} GB dari ${quota.total.toStringAsFixed(0)} GB', style: const TextStyle(fontWeight: FontWeight.w500)),
                 Text('${quota.persentaseSisaInt}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // (Social quota card tetap sama untuk saat ini)
  Widget _buildSocialQuotaCard(List<Map<String, dynamic>> quotas) {
    return Card(
      elevation: 2,
      shadowColor: Colors.deepPurple.withAlpha(26),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Penggunaan Media Sosial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...quotas.map((q) => _socialQuotaItem(q, q['color_hex'] ?? '#4267B2')),
          ],
        ),
      ),
    );
  }

  Widget _socialQuotaItem(Map<String, dynamic> quota, String colorHex) {
    final total = (quota['total'] ?? 0).toDouble();
    final used = (quota['used'] ?? 0).toDouble();
    final percentage = total > 0 ? (used / total) : 0.0;
    final color = Color(int.parse(colorHex.replaceAll('#', '0xFF')));

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(quota['app'] ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('${used.toStringAsFixed(1)} GB / ${total.toStringAsFixed(1)} GB', style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[300],
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
