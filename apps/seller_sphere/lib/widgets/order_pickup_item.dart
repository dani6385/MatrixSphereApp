import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../models/shopsphere_order.dart';
import 'order_verification_dialog.dart';
import 'order_pickup/order_header.dart';
import 'order_pickup/order_details.dart';
import 'order_pickup/order_status_info.dart';
import 'order_pickup/order_actions.dart';

class OrderPickupItem extends StatelessWidget {
  final ShopsphereOrder order;
  final Function(String) onNavigateToChat;
  final VoidCallback onUpdate;

  const OrderPickupItem({
    super.key,
    required this.order,
    required this.onNavigateToChat,
    required this.onUpdate,
  });

  void _showVerificationDialog(BuildContext context, ShopsphereOrder order) {
    showDialog(
      context: context,
      builder: (context) => OrderVerificationDialog(
        order: order,
        onVerifySuccess: () {
          // The onUpdate callback signals the parent widget to handle the state change.
          // The parent is responsible for creating a new order object with the updated status.
          onUpdate();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPickedUp = order.status == "Selesai Diambil";

    return Card(
      color: isPickedUp
          ? kSlateBorderDark.withValues(alpha: 0.4)
          : kSlateSurfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OrderHeader(order: order, onNavigateToChat: onNavigateToChat),
            const SizedBox(height: 8),
            OrderDetails(order: order),
            const SizedBox(height: 6),
            OrderStatusInfo(status: order.status),
            const SizedBox(height: 10),
            OrderActions(
              order: order,
              onUpdate: onUpdate,
              onShowVerificationDialog: _showVerificationDialog,
            ),
          ],
        ),
      ),
    );
  }
}
