// lib/screens/management/widgets/cashier_cart_list.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';
import 'cart_item_tile.dart';

class CashierCartList extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(int index, int newQuantity) onQuantityChanged;
  final Function(int index) onRemove;

  const CashierCartList({
    super.key,
    required this.cartItems,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return const Center(
        child: Text(
          'Keranjang kosong.\nCari atau pindai produk untuk memulai.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return CartItemTile(
          cartItem: item,
          onQuantityChanged: (newQuantity) => onQuantityChanged(index, newQuantity),
          onRemove: () => onRemove(index),
        );
      },
    );
  }
}