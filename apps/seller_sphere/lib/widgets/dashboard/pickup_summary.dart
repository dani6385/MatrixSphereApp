import 'package:flutter/material.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';

class PickupSummary extends StatelessWidget {
  final List<ShopsphereOrder> orders;

  const PickupSummary({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final todayOrders = orders.where((it) => it.dayIndex == 6).toList();
    final awaitingPickupCount = todayOrders.where((it) => it.status != "Selesai Diambil").length;
    final pickedUpCount = todayOrders.where((it) => it.status == "Selesai Diambil").length;

    return Row(
      children: [
        Expanded(
          child: Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
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
                          color: const Color(0xFFFFA500).withAlpha(38), // 0.15 alpha
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.warning, color: Color(0xFFFFA500), size: 18),
                      ),
                      const SizedBox(width: 8),
                      Text("Belum Diambil",
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(204))), // 0.8 alpha
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("$awaitingPickupCount Paket",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFFFA500))),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
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
                          color: const Color(0xFF4CAF50).withAlpha(38), // 0.15 alpha
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 18),
                      ),
                      const SizedBox(width: 8),
                      Text("Selesai Diambil",
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(204))), // 0.8 alpha
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("$pickedUpCount Paket",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF4CAF50))),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
