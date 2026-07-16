import 'package:flutter/material.dart';
import 'package:matrix/screens/seller/models/seller_model.dart';

class SellerCard extends StatelessWidget {
  final Seller seller;

  const SellerCard({
    super.key,
    required this.seller,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPending = seller.status.contains('PENDING');
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(seller.icon, color: seller.iconColor, size: 22),
                  const SizedBox(width: 10),
                  Text(seller.storeName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: isPending ? Colors.transparent : seller.statusColor.withAlpha(51),
                  border: isPending ? Border.all(color: seller.statusColor, width: 1) : null,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(seller.status, style: TextStyle(color: seller.statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(Icons.person_outline, 'Pemilik: ${seller.ownerName}'),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.email_outlined, seller.email),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.phone_outlined, seller.phone),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 16),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
