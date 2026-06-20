import 'package:flutter/material.dart';

class MadingSection extends StatelessWidget {
  final Color cardColor;
  final Color accentColor;

  const MadingSection({
    super.key,
    required this.cardColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> madingMessages = [
      {'title': 'Promo Paket Hebat!', 'desc': 'Hemat 30% Bulan Ini'},
      {'title': 'Jaringan Stabil', 'desc': 'Semua Sistem OK'},
      {'title': 'Event Spesial', 'desc': 'WiFi Gratis @ Alun-Alun Sabtu Ini'},
    ];

    return Column(
      children: madingMessages
          .map(
            (msg) => _buildMadingCard(
              msg['title']!,
              msg['desc']!,
            ),
          )
          .toList(),
    );
  }

  Widget _buildMadingCard(String title, String desc) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardColor,
      child: ListTile(
        leading: Icon(Icons.info_outline, color: accentColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          desc,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),
        onTap: () {
          // Aksi ketika mading di-tap
        },
      ),
    );
  }
}
