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
      // PERBAIKAN: Berikan pesan yang lebih informatif dan menarik
      // saat belum ada pesanan yang masuk.
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text('Belum ada pesanan masuk',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Semua pesanan baru dari pelanggan akan ditampilkan di sini.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }
    // Mengurutkan pesanan dari yang terbaru secara aman dengan membuat salinan list
    final sortedOrders = List<Order>.from(orders)
      ..sort((a, b) => b.orderDate.compareTo(a.orderDate));

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
