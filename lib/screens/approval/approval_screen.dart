import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class ApprovalScreen extends StatelessWidget {
  const ApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        backgroundColor: kDarkBackground,
        title: const Text('Matrix Sphere',
            style: TextStyle(color: kDarkTextPrimary)),
        actions: [
          IconButton(
            onPressed: () {},
            icon:
                const Icon(Icons.chat_bubble_outline, color: kDarkTextPrimary),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ANTREAN PERSETUJUAN',
                style: TextStyle(
                    color: kDarkTextPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text(
                'Otorisasi pendaftaran seller, limit keuangan, dan akses sistem',
                style: TextStyle(color: kDarkTextSecondary)),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kDarkTextSecondary,
                  ),
                  child: const Text('Pending 3'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {},
                  child: const Text('Histori',
                      style: TextStyle(color: kDarkTextPrimary)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildApprovalCard(
                    title: 'Kenaikan Limit Transaksi',
                    subtitle: 'Diajukan oleh: Julia Spelica',
                    description:
                        'Toko \'Cyber Tech Store\' mengajukan penaikan limit harian dari Rp 50M ke Rp 150M.',
                    icon: Icons.show_chart,
                    iconColor: kBrandSecondary,
                  ),
                  const SizedBox(height: 10),
                  _buildApprovalCard(
                    title: 'Persetujuan Seller: Quantum Computing',
                    subtitle: 'Diajukan oleh: Budi Hermawan',
                    description:
                        'Pendaftaran toko baru oleh Budi Hermawan (budisphere.eng) membutuhkan verifikasi admin.',
                    icon: Icons.store,
                    iconColor: kSoftTeal,
                  ),
                  const SizedBox(height: 10),
                  _buildApprovalCard(
                    title: 'Persetujuan Seller: Cyber Tech Store',
                    subtitle: 'Diajukan oleh: Julia Spelica',
                    description:
                        'Pendaftaran toko baru oleh Julia Spelica (juliaspelica.com) membutuhkan verifikasi admin.',
                    icon: Icons.store,
                    iconColor: kSoftTeal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalCard(
      {required String title,
      required String subtitle,
      required String description,
      required IconData icon,
      required Color iconColor}) {
    return Card(
      color: kDarkTextSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 10),
                Text(title,
                    style: const TextStyle(
                        color: kDarkTextPrimary, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 5),
            Text(subtitle, style: const TextStyle(color: kDarkTextSecondary)),
            const SizedBox(height: 10),
            Text(description, style: const TextStyle(color: kDarkTextSecondary)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child:
                      const Text('Tolak', style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Setujui'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
