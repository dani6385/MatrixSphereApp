import 'package:flutter/material.dart';
import '../models/shopsphere_order.dart';

const Color warmOrange = Color(0xFFFFA726);
const Color softTeal = Color(0xFF4DB6AC);
const Color surfaceVariantColor = Color(0xFF1B263B);

class PickupSummary extends StatelessWidget {
  final List<ShopsphereOrder> orders;
  const PickupSummary({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final todayOrders = orders.where((o) => o.dayIndex == 6).toList();
    final awaitingPickupCount = todayOrders.where((o) => o.status != "Selesai Diambil").length;
    final pickedUpCount = todayOrders.where((o) => o.status == "Selesai Diambil").length;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: "Belum Diambil",
            count: awaitingPickupCount,
            icon: Icons.warning,
            color: warmOrange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            title: "Selesai Diambil",
            count: pickedUpCount,
            icon: Icons.check_circle,
            color: softTeal,
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
      color: surfaceVariantColor,
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
                Text(title, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "$count Paket",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: color),
            )
          ],
        ),
      ),
    );
  }
}
