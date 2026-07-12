import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../models/shopsphere_order.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const ActionButton({
    super.key, 
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 14, color: Colors.white70),
        label: Text(
          text,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: kSlateSurfaceDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
          elevation: 2,
        ),
      ),
    );
  }
}

class OrderActions extends StatelessWidget {
  final ShopsphereOrder order;
  final VoidCallback onUpdate;
  final Function(BuildContext, ShopsphereOrder) onShowVerificationDialog;

  const OrderActions({
    super.key,
    required this.order,
    required this.onUpdate,
    required this.onShowVerificationDialog,
  });

  @override
  Widget build(BuildContext context) {
    final isPickedUp = order.status == "Selesai Diambil";
    if (isPickedUp) {
      return const SizedBox.shrink();
    }

    if (order.status == "Perlu Dipacking") {
      return SizedBox(
        width: double.infinity,
        height: 40,
        child: ElevatedButton.icon(
          onPressed: () {
            // In a real app: viewModel.finishPacking(order.id)
            
            onUpdate();
          },
          icon: const Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.black,
          ),
          label: const Text(
            "Barang Selesai, Silakan Ambil",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: kNeonCyan,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    } else if (order.status == "Siap Diambil") {
      return Row(
        children: [
          Expanded(
            flex: 13,
            child: ActionButton(
              text: "Hubungi Pembeli",
              icon: Icons.call,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 12,
            child: ActionButton(
              text: "Cetak Nota",
              icon: Icons.print,
              onTap: () {},
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 18,
            child: SizedBox(
              height: 36,
              child: ElevatedButton.icon(
                onPressed: () => onShowVerificationDialog(context, order),
                icon: const Icon(
                  Icons.check_circle,
                  size: 14,
                  color: Colors.black,
                ),
                label: const Text(
                  "Konfirmasi Diambil",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSoftTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
