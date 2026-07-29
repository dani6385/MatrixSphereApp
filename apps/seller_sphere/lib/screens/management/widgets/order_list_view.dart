import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

import 'order_detail_screen.dart';
import 'order_card.dart';

/// Widget untuk menampilkan daftar pesanan dalam bentuk ListView.
class OrderListView extends StatelessWidget {
  final List<Order> orders;
  const OrderListView({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    // Jika tidak ada pesanan, tampilkan pesan di tengah.
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada pesanan.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    // Mengurutkan pesanan dari yang terbaru secara aman dengan membuat salinan list
    final sortedOrders = List<Order>.from(orders)..sort((a, b) => b.orderDate.compareTo(a.orderDate));

    return ListView.builder(
      itemCount: sortedOrders.length,
      itemBuilder: (context, index) {
        final order = sortedOrders[index];
        return OrderCard(
          order: order,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderDetailScreen(order: order),
              ),
            );
          },
        );
      },
    );
  }
}