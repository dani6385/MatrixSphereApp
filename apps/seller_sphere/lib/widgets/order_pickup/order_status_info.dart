import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class OrderStatusInfo extends StatelessWidget {
  final String status;

  const OrderStatusInfo({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == "Siap Diambil") {
      return const Row(
        children: [
          Icon(Icons.check_circle, color: kSoftTeal, size: 12),
          SizedBox(width: 4),
          Text(
            "Verifikasi Barcode & PIN Aman Aktif",
            style: TextStyle(
              fontSize: 10,
              color: kSoftTeal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else if (status == "Perlu Dipacking") {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: kWarmOrange.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.warning, color: kWarmOrange, size: 14),
            SizedBox(width: 8),
            Text(
              "Silakan lakukan packing untuk pesanan ini.",
              style: TextStyle(
                fontSize: 11,
                color: kWarmOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink(); // Return an empty widget if no specific info is needed
    }
  }
}
