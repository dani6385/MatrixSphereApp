import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../models/shopsphere_order.dart';
import 'status_badge.dart';

class OrderHeader extends StatelessWidget {
  final ShopsphereOrder order;
  final Function(String) onNavigateToChat;

  const OrderHeader({
    super.key,
    required this.order,
    required this.onNavigateToChat,
  });

  @override
  Widget build(BuildContext context) {
    final isPickedUp = order.status == "Selesai Diambil";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.id,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isPickedUp
                      ? Colors.white70
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Pembeli: ${order.customerName}",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                  IconButton(
                    onPressed: () => onNavigateToChat(order.customerName),
                    icon: const Icon(
                      Icons.chat,
                      color: kNeonCyan,
                      size: 14,
                    ),
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                    splashRadius: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
        StatusBadge(status: order.status),
      ],
    );
  }
}
