import 'package:flutter/material.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';

class PickupSummary extends StatelessWidget {
  final List<ShopsphereOrder> orders;

  const PickupSummary({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final readyToPickup = orders.where((o) => o.status == 'Siap Diambil').length;
    final needsPacking = orders.where((o) => o.status == 'Perlu Dipacking').length;

    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Siap Diambil', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(readyToPickup.toString(), style: const TextStyle(fontSize: 24)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text('Perlu Dipacking', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(needsPacking.toString(), style: const TextStyle(fontSize: 24)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
