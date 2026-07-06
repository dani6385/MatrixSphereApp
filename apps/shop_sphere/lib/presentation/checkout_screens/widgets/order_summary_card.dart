import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';
import '../../cart_screens/providers/cart_provider.dart';

/// Widget yang menampilkan ringkasan pesanan dalam sebuah Card.
///
/// Menampilkan daftar item, kuantitas, harga per item, dan total harga.
class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.cart,
  });

  final CartProvider cart;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: cart.items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = cart.items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text('${item.quantity} x Rp ${item.price.toStringAsFixed(0)}'),
                trailing: Text('Rp ${(item.quantity * item.price).toStringAsFixed(0)}'),
              );
            },
          ),
          const Divider(height: 1, thickness: 2),
          ListTile(
            title: const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(
              'Rp ${cart.totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}