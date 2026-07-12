import 'package:flutter/material.dart';
import 'package:seller_sphere/models/shopsphere_order.dart';
import 'package:seller_sphere/utils/formatting.dart';

class OrderPickupItem extends StatelessWidget {
  final ShopsphereOrder order;
  final VoidCallback onAction;

  const OrderPickupItem({
    super.key,
    required this.order,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.id,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text('Pelanggan: ${order.customerName}', style: const TextStyle(fontSize: 12)),
                  Text('${order.productName} x${order.quantity}', style: const TextStyle(fontSize: 11)),
                  Text(
                    formatRupiah(order.totalAmount),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    switch (order.status) {
      case 'Perlu Dipacking':
        return ElevatedButton.icon(
          onPressed: onAction,
          icon: const Icon(Icons.inventory_2_outlined, size: 16),
          label: const Text('Selesaikan', style: TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
          ),
        );
      case 'Siap Diambil':
        return ElevatedButton.icon(
          onPressed: onAction,
          icon: const Icon(Icons.qr_code_scanner, size: 16),
          label: const Text('Verifikasi', style: TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00FFFF),
            foregroundColor: Colors.black,
          ),
        );
      case 'Selesai Diambil':
        return const Icon(Icons.check_circle, color: Colors.green);
      default:
        return const SizedBox.shrink();
    }
  }
}
