
import 'package:flutter/material.dart';
import '../models/quota_model.dart';

class DetailQuotaScreen extends StatelessWidget {
  final Map<String, dynamic> quotaData;

  const DetailQuotaScreen({super.key, required this.quotaData});

  @override
  Widget build(BuildContext context) {
    // --- PERBAIKAN: Gunakan kunci yang benar sesuai yang dikirim dari HomeScreen ---
    final mainQuota = Quota.fromMap(Map<String, dynamic>.from(quotaData['kuota_utama'] ?? {}));
    final bonusQuota = Quota.fromMap(Map<String, dynamic>.from(quotaData['bonus_kuota'] ?? {}));
    final socialQuota = Quota.fromMap(Map<String, dynamic>.from(quotaData['kuota_sosmed'] ?? {})); // Menyiapkan untuk masa depan

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
          // Tampilkan kartu hanya jika datanya ada (total > 0)
          if (mainQuota.total > 0) _buildQuotaCard(mainQuota, Colors.green),
          const SizedBox(height: 16),
          if (bonusQuota.total > 0) _buildQuotaCard(bonusQuota, Colors.orange),
          const SizedBox(height: 16),
          if (socialQuota.total > 0) _buildQuotaCard(socialQuota, Colors.blue),
          const SizedBox(height: 16),
          // Widget statis untuk Penggunaan Media Sosial bisa kita nonaktifkan sementara
          // atau kita buat dinamis nanti.
        ],
      ),
    );
  }

  // --- REFACTOR: Widget menjadi lebih generik untuk semua jenis kuota ---
  Widget _buildQuotaCard(Quota quota, Color progressColor) {
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
              color: progressColor, // Menggunakan warna dari parameter
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${quota.sisa.toStringAsFixed(1)} GB dari ${quota.total.toStringAsFixed(0)} GB', style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(
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
}
