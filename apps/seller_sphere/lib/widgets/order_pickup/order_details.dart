import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/shopsphere_order.dart';

class OrderDetails extends StatelessWidget {
  final ShopsphereOrder order;

  const OrderDetails({super.key, required this.order});

  String _formatRupiah(double amount) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${order.productName} x${order.quantity}",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _formatRupiah(order.totalAmount),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "No. HP Pembeli: ${order.courierPhone}",
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }
}
