import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

/// Widget untuk menampilkan satu item dalam keranjang belanja kasir.
class CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.cartItem,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
            .format(cartItem.product.sellingPrice);

    return ListTile(
      title: Text(cartItem.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(formattedPrice, style: const TextStyle(color: kBrandPrimary)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed: cartItem.quantity > 1
                ? () => onQuantityChanged(cartItem.quantity - 1)
                : onRemove,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '${cartItem.quantity}',
              style: AppStyles.titleMedium,
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onPressed: () => onQuantityChanged(cartItem.quantity + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: IconButton(
        icon: Icon(icon),
        iconSize: 16,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        color: Colors.black87,
        splashRadius: 16,
        disabledColor: Colors.grey.shade400,
      ),
    );
  }
}