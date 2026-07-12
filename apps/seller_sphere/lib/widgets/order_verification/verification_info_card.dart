import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../models/shopsphere_order.dart';

class VerificationInfoCard extends StatelessWidget {
  final ShopsphereOrder order;
  const VerificationInfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kDarkBackground.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pesanan: ${order.id}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kNeonCyan)),
            Text("Pelanggan: ${order.customerName}", style: const TextStyle(fontSize: 12, color: Colors.white70)),
            Text("Produk: ${order.productName} x${order.quantity}", style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
