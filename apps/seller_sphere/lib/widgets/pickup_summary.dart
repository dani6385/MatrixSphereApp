import 'package:flutter/material.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';

class PickupSummary extends StatelessWidget {
  final List<ShopsphereOrder> orders;

  const PickupSummary({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ringkasan Pengambilan Pesanan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...orders.map((order) => _buildOrderItem(order, context)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(ShopsphereOrder order, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order.id, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('Status: ${order.status}', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade300),
            child: const Text('Lihat Rincian'),
          ),
        ],
      ),
    );
  }
}
