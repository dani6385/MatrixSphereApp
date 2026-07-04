import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
// Impor provider dari lokasi yang benar
import 'package:seller_sphere/presentation/order_screens/providers/order_provider.dart';

class OrderListScreen extends ConsumerWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Gunakan ref.watch untuk mendapatkan state dari provider
    final orderState = ref.watch(orderProvider);
    final orders = orderState.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pesanan'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text('Pesanan #${order.id} - ${order.customerName}'),
              subtitle: Text(
                '${order.items.length} item • Rp ${order.totalAmount.toStringAsFixed(0)}\n${DateFormat('dd MMM yyyy, HH:mm').format(order.orderDate)}',
              ),
              trailing: Chip(
                label: Text(
                  _getStatusText(order.status),
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: _getStatusColor(order.status),
              ),
              isThreeLine: true,
              onTap: () {
                context.push('/orders/${order.id}');
              },
            ),
          );
        },
      ),
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return 'Diproses';
      case OrderStatus.readyForPickup:
        return 'Siap Diambil';
      case OrderStatus.completed:
        return 'Selesai';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return Colors.orange.shade700;
      case OrderStatus.readyForPickup:
        return Colors.blue.shade700;
      case OrderStatus.completed:
        return Colors.green.shade700;
    }
  }
}
