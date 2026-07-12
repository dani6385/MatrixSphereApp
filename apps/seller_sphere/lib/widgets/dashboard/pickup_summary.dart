import 'package:flutter/material.dart';

class PickupSummary extends StatelessWidget {
  final int awaitingPickupCount;
  final int pickedUpCount;

  const PickupSummary({super.key, required this.awaitingPickupCount, required this.pickedUpCount});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: "Belum Diambil",
            count: awaitingPickupCount,
            icon: Icons.warning,
            color: Color(0xFFFFA500),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: "Selesai Diambil",
            count: pickedUpCount,
            icon: Icons.check_circle,
            color: Color(0xFF4CAF50),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  
  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "$count Paket",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
